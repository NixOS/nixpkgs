# Test that an unprivileged user can reauthenticate *themselves* using
# their own password, without the reauthenticating program needing to
# be set-id itself.  This is the main function of the set-id unix_chkpwd(8)
# helper binary.
#
# Note: this test validates the behavior of a set-id binary, and
# therefore requires test VMs.

{ lib, pkgs, ... }:
let
  # You would _think_ we could do this entirely in the top-level test script
  # using machine.wait_until_tty_matches and .send_chars, but that has proven
  # unreliable due to unrelated console spew from systemd's logs.  Thus, expect.
  makeUserTestScript = pkgs.writeScript "pam-unix-chkpwd-tester" ''
    #! ${pkgs.expect}/bin/expect -f
    set pamtester {${pkgs.pamtester}/bin/pamtester}
    set user [lindex $argv 0]
    set password [lindex $argv 1]
    set should_succeed [lindex $argv 2]

    log_user 1
    set junk 0
    set success 0
    set failure 0

    spawn $pamtester login $user authenticate

    # caution: this has to come after the spawn or it'll be ignored
    expect_after {
      -re {^[\r\n]+} { exp_continue }
      -re {^.+} {
        puts "ERROR: unexpected: $expect_out(buffer)"
        set junk 1
        exp_continue
      }
      eof {
        puts "ERROR: unexpected EOF"
        exit 1
      }
      timeout {
        puts "ERROR: timed out waiting for next message"
        exit 1
      }
    }

    expect "^Password: $"
    send "$password\n"

    expect {
      -re {^pamtester: successfully authenticated\M} {
        set success 1
        exp_continue
      }
      -re {^pamtester: Authentication failure\M} {
        set failure 1
        exp_continue
      }
      eof
    }

    set status [wait]
    if { [llength $status] > 4 } {
      if { [lindex $status 4] == "CHILDKILLED" } {
        puts "ERROR: pamtester process killed by [lindex $status 5]"
      } else {
        puts "ERROR: strange wait status [lrange $status 4 end]"
      }
      exit 1
    }
    if { [lindex $status 2] == -1 } {
      puts "ERROR: wait failed, errno=[lindex $status 3]"
      exit 1
    }

    set exit_ok [expr [lindex $status 3] == 0]

    if {$junk} {
      exit 1
    }
    if {$success && $failure} {
      puts "ERROR: got both success and failure messages"
      exit 1
    }
    if {!$success && !$failure} {
      puts "ERROR: got neither success nor failure messages"
      exit 1
    }
    if {$should_succeed && ($failure || !$exit_ok)} {
      puts "FAIL: authentication failed (should have succeeded)"
      exit 1
    }
    if {!$should_succeed && ($success || $exit_ok)} {
      puts "FAIL: authentication succeeded (should have failed)"
      exit 1
    }
    puts "PASS"
    exit 0
  '';
  correctPassword = "correct-password-for-alice";
  wrongPassword = "wrong-password-for-alice";
  makeTestVM =
    mutableUsers: extraOptions:
    lib.recursiveUpdate {
      users.mutableUsers = mutableUsers;
      users.users = {
        alice = {
          description = "Alice Normaluser";
          isNormalUser = true;
          password = correctPassword;
        };
      };
    } extraOptions;
in
{
  name = "pam-unix-chkpwd-self";

  nodes = {
    mutable-legacy = makeTestVM true { };
    immutable-legacy = makeTestVM false { };
    mutable-userborn = makeTestVM true { services.userborn.enable = true; };
    immutable-userborn = makeTestVM false { services.userborn.enable = true; };
    # tests with systemd.sysusers.enable = true are disabled because
    # systemd-sysusers (currently) cannot create normal users.
    #mutable-userborn = makeTestVM true { systemd.sysusers.enable = true; };
    #immutable-userborn = makeTestVM false { systemd.sysusers.enable = true; };
  };

  testScript = ''
    script = "${makeUserTestScript}"
    correctPassword = "${correctPassword}"
    wrongPassword = "${wrongPassword}"

    for m in machines:
      assert isinstance(m, QemuMachine)
      m.start()
      m.wait_for_unit("multi-user.target")

      with subtest(f"{m.name}: correct password"):
        m.succeed(
          f"su -c '\"{script}\" alice {correctPassword} 1' -l alice 2>&1"
        )

      with subtest(f"{m.name}: wrong password"):
        m.succeed(
          f"su -c '\"{script}\" alice {wrongPassword} 0' -l alice 2>&1"
        )
  '';
}

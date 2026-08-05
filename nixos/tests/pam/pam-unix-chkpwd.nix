# Test that PAM is able to distinguish expired from active accounts
# even when invoked from an unprivileged context (as is done by sshd).
# This is the purpose of the set-id unix_chkpwd(8) helper binary.
#
# Note: this test validates the behavior of a set-id binary, and
# therefore requires test VMs.
#
# Note: this test assumes that the system clock within each test VM
# is set to a date and time no earlier than 1970-01-03T00:00:01Z.

{ lib, pkgs, ... }:
let
  testOnlySSHCredentials =
    pkgs.runCommand "pam-unix-chkpwd-keygen"
      {
        nativeBuildInputs = [ pkgs.openssh ];
      }
      ''
        mkdir -p $out
        ssh-keygen -t ed25519 -N "" -f $out/alice
      '';
  makeTestScript =
    toUser:
    pkgs.writeShellScript "pam-unix-chkpwd-test-ssh-to-${toUser}" ''
      set -xeuo pipefail
      sshbin=${pkgs.openssh}/bin

      if [ ! -f "$HOME/.ssh/config" ]; then
        mkdir -p "$HOME/.ssh"
        chmod 700 "$HOME/.ssh"
        echo "StrictHostKeyChecking accept-new" > "$HOME/.ssh/config"
        chmod 600 "$HOME/.ssh/config"
      fi

      eval $($sshbin/ssh-agent)
      $sshbin/ssh-add ${testOnlySSHCredentials}/alice
      $sshbin/ssh-add -l &>2

      exec $sshbin/ssh -v ${toUser}@localhost ${pkgs.coreutils}/bin/id
    '';
  makeTestVM =
    mutableUsers: extraOptions:
    lib.recursiveUpdate {
      services.openssh.enable = true;
      users.mutableUsers = mutableUsers;
      users.users = {
        alice = {
          description = "This account will attempt to ssh to the other accounts.";
          isNormalUser = true;
          hashedPassword = ""; # ensure initial "su alice" succeeds
        };
        bob = {
          description = "This account is active and should be ssh-able from alice.";
          isNormalUser = true;
          hashedPassword = null;
          openssh.authorizedKeys.keyFiles = [
            "${testOnlySSHCredentials}/alice.pub"
          ];
        };
        carol = {
          description = "This account is expired and should not be ssh-able from alice.";
          isNormalUser = true;
          hashedPassword = null;
          openssh.authorizedKeys.keyFiles = [
            "${testOnlySSHCredentials}/alice.pub"
          ];
          # The account expiration date is recorded in /etc/shadow as
          # a count of days since 1970-01-01.  shadow(5) warns that an
          # expiration date *of* 1970-01-01 (which translates to 0 in
          # the expiration date field) cannot be used, as some systems
          # interpret an explicit zero in this field as "no expiration date".
          # shadow(5) does not say whether dates *before* 1970-01-01 are
          # permissible.  Thus, we use 1970-01-02 (1 in the field) and rely
          # on the system clock being set later than that.
          expires = "1970-01-02";
        };
      };
    } extraOptions;
in
{
  name = "pam-unix-chkpwd";

  nodes = {
    mutable-legacy = makeTestVM true { };
    immutable-legacy = makeTestVM false { };
    # tests with services.userborn.enable = true are disabled because
    # userborn currently ignores users.users.<name>.expires.
    #mutable-userborn = makeTestVM true { services.userborn.enable = true; };
    #immutable-userborn = makeTestVM false { services.userborn.enable = true; };
    # tests with systemd.sysusers.enable = true are disabled because
    # systemd-sysusers (currently) cannot create normal users.
    #mutable-userborn = makeTestVM true { systemd.sysusers.enable = true; };
    #immutable-userborn = makeTestVM false { systemd.sysusers.enable = true; };
  };

  testScript = ''
    import re

    testBobScript = "${makeTestScript "bob"}"
    testCarolScript = "${makeTestScript "carol"}"
    expectedBobOutput = re.compile(r"^uid=[0-9]+\(bob\) ", re.MULTILINE)

    for m in machines:
      m.start()
      m.wait_for_unit("sshd.service")
      m.wait_for_unit("systemd-user-sessions.service")

      with subtest(f"{m.name}: alice should be able to ssh bob@localhost"):
        bobOutput = m.succeed(f"su -c '{testBobScript}' -l alice")
        log.debug(f"{m.name}: bob output: {bobOutput}")
        t.assertIsNotNone(expectedBobOutput.search(bobOutput))

      with subtest(f"{m.name}: alice should not be able to ssh carol@localhost"):
        m.fail(f"su -c '{testCarolScript}' -l alice")
  '';
}

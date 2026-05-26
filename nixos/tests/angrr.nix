{ pkgs, ... }:
let
  drvForTest =
    name:
    pkgs.runCommand "angrr-test-${name}" { } ''
      mkdir --parents "$out"
      echo "${name}" >"$out/${name}"
    '';
in
{
  name = "angrr";
  nodes = {
    machine = {
      services.angrr = {
        enable = true;
        settings = {
          temporary-root-policies = {
            result = {
              path-regex = "/result[^/]*$";
              period = "7d";
            };
            direnv = {
              path-regex = "/\\.direnv/";
              period = "14d";
            };
          };
          profile-policies = {
            system = {
              profile-paths = [ "/nix/var/nix/profiles/system" ];
              keep-since = "7d"; # do not keep based on time
              keep-latest-n = 2; # keep latest
              keep-current-system = true;
              keep-booted-system = true;
            };
            user = {
              profile-paths = [
                "~/.local/state/nix/profiles/profile"
                "/nix/var/nix/profiles/per-user/root/profile"
              ];
              # keep-since = "0d"; # do not keep based on time
              keep-latest-n = 2;
            };
          };
          touch = {
            project-globs = [
              "!result-glob-ignored"
            ];
          };
        };
      };
      # `angrr.service` integrates to `nix-gc.service` by default
      nix.gc.automatic = true;

      # Create a normal nix user for test
      users.users.normal.isNormalUser = true;
      # For `nix build /run/current-system --out-link`,
      # `nix-build` does not support this use case.
      nix.settings.experimental-features = [ "nix-command" ];

      # Test direnv integration
      programs.direnv.enable = true;
      # Verbose logging for angrr in direnv
      environment.variables.ANGRR_DIRENV_LOG = "debug";

      # Add some store paths to machine for test
      environment.etc."drvs-for-test".text = ''
        ${drvForTest "drv1"}
        ${drvForTest "drv2"}
        ${drvForTest "drv3"}
        ${drvForTest "drv4"}
        ${drvForTest "drv5"}
        ${drvForTest "drv6"}
        ${drvForTest "drv7"}
        ${drvForTest "drv8"}
        ${drvForTest "fake-booted-system"}
      '';

      # Unit start limit workaround
      systemd.services.angrr.unitConfig.StartLimitBurst = 10;
    };
  };

  testScript = ''
    start_all()

    machine.wait_for_unit("default.target")

    machine.systemctl("stop nix-gc.timer")

    # Creates some auto gc roots
    # Use /run/current-system so that we do not need to build anything new
    machine.succeed("nix build /run/current-system --out-link /tmp/result-root-auto-gc-root-1")
    machine.succeed("nix build /run/current-system --out-link /tmp/result-root-auto-gc-root-2")
    machine.succeed("su normal --command 'nix build /run/current-system --out-link /tmp/result-user-auto-gc-root-1'")
    machine.succeed("su normal --command 'nix build /run/current-system --out-link /tmp/result-user-auto-gc-root-2'")

    machine.systemctl("start nix-gc.service")
    # Not auto gc root will be removed
    machine.succeed("readlink /tmp/result-root-auto-gc-root-1")
    machine.succeed("readlink /tmp/result-root-auto-gc-root-2")
    machine.succeed("readlink /tmp/result-user-auto-gc-root-1")
    machine.succeed("readlink /tmp/result-user-auto-gc-root-2")

    # Change time to 8 days after (greater than 7d)
    machine.succeed("date -s '8 days'")

    # Touch GC roots `-2`
    machine.succeed("touch /tmp/result-root-auto-gc-root-2 --no-dereference")
    machine.succeed("touch /tmp/result-user-auto-gc-root-2 --no-dereference")

    machine.systemctl("start angrr.service")
    # Only GC roots `-1` are removed
    machine.succeed("test ! -e /tmp/result-root-auto-gc-root-1")
    machine.succeed("readlink  /tmp/result-root-auto-gc-root-2")
    machine.succeed("test ! -e /tmp/result-user-auto-gc-root-1")
    machine.succeed("readlink  /tmp/result-user-auto-gc-root-2")

    # Change time again
    machine.succeed("date -s '8 days'")
    machine.systemctl("start angrr.service")
    # All auto GC roots are removed
    machine.succeed("test ! -e /tmp/result-root-auto-gc-root-2")
    machine.succeed("test ! -e /tmp/result-user-auto-gc-root-2")

    # Direnv integration test
    machine.succeed("mkdir /tmp/test-direnv")
    machine.succeed("echo >/tmp/test-direnv/.envrc") # Simply create an empty .envrc
    machine.succeed("nix build /run/current-system --out-link /tmp/test-direnv/.direnv/gc-root")
    machine.succeed("nix build /run/current-system --out-link /tmp/test-direnv/result")
    machine.succeed("cd /tmp/test-direnv; direnv allow; direnv exec . true")

    # The root will be removed if we does not use the direnv recently
    machine.succeed("date -s '15 days'")
    machine.systemctl("start angrr.service")
    machine.succeed("test ! -e /tmp/test-direnv/.direnv/gc-root")
    machine.succeed("test ! -e /tmp/test-direnv/result")

    # Recreate the root
    machine.succeed("nix build /run/current-system --out-link /tmp/test-direnv/.direnv/gc-root")
    machine.succeed("nix build /run/current-system --out-link /tmp/test-direnv/result")
    machine.succeed("nix build /run/current-system --out-link /tmp/test-direnv/result-glob-ignored")
    machine.succeed("nix build /run/current-system --out-link /tmp/test-outside-direnv/result")

    # The root will not be remove if we use the direnv recently
    machine.succeed("date -s '15 days'")
    # test the case that $PWD is different from project root
    machine.succeed("cd /tmp; direnv exec /tmp/test-direnv true")
    machine.systemctl("start angrr.service")
    machine.succeed("readlink  /tmp/test-direnv/.direnv/gc-root")
    machine.succeed("readlink  /tmp/test-direnv/result")
    machine.succeed("test ! -e /tmp/test-direnv/result-glob-ignored")
    machine.succeed("test ! -e /tmp/test-outside-direnv/result")

    # System profile policy test
    # Create a profile for test
    machine.succeed("mkdir /tmp/profile-test")
    machine.succeed("nix-env --profile /nix/var/nix/profiles/system --set ${drvForTest "drv1"}") # generation 1
    machine.succeed("nix-env --profile /nix/var/nix/profiles/system --set ${drvForTest "drv2"}") # generation 2
    machine.succeed("nix-env --profile /nix/var/nix/profiles/system --set ${drvForTest "drv3"}") # generation 3
    machine.succeed("ln --symbolic --force --no-dereference ${drvForTest "fake-booted-system"} /run/booted-system")
    machine.succeed("nix-env --profile /nix/var/nix/profiles/system --set /run/booted-system")   # generation 4
    machine.succeed("nix-env --profile /nix/var/nix/profiles/system --set /run/current-system")  # generation 5
    machine.succeed("date -s '8 days'")
    machine.succeed("nix-env --profile /nix/var/nix/profiles/system --set ${drvForTest "drv4"}") # generation 6
    machine.succeed("nix-env --profile /nix/var/nix/profiles/system --set ${drvForTest "drv5"}") # generation 7
    machine.succeed("nix-env --profile /nix/var/nix/profiles/system --set ${drvForTest "drv6"}") # generation 8
    machine.succeed("nix-env --profile /nix/var/nix/profiles/system --set ${drvForTest "drv7"}") # generation 9
    machine.succeed("nix-env --profile /nix/var/nix/profiles/system --set ${drvForTest "drv8"}") # generation 10
    # Rollback to generation 2 to simulate current system
    for _ in range(0, 10 - 2):
      machine.succeed("nix-env --rollback --profile /nix/var/nix/profiles/system")

    # Run policy
    machine.systemctl("start angrr.service")

    # Test
    machine.succeed("sh -c 'test $(readlink /nix/var/nix/profiles/system) = system-2-link'")
    machine.succeed("test ! -e /nix/var/nix/profiles/system-1-link")
    machine.succeed("readlink  /nix/var/nix/profiles/system-2-link")  # Keep since it is current generation
    machine.succeed("test ! -e /nix/var/nix/profiles/system-3-link")
    machine.succeed("readlink  /nix/var/nix/profiles/system-4-link")  # Keep by keep-booted-system
    machine.succeed("readlink  /nix/var/nix/profiles/system-5-link")  # Keep by keep-current-system
    machine.succeed("readlink  /nix/var/nix/profiles/system-6-link")  # Keep by keep-since
    machine.succeed("readlink  /nix/var/nix/profiles/system-7-link")  # Keep by keep-since
    machine.succeed("readlink  /nix/var/nix/profiles/system-8-link")  # Keep by keep-since
    machine.succeed("readlink  /nix/var/nix/profiles/system-9-link")  # Keep by keep-latest-n
    machine.succeed("readlink  /nix/var/nix/profiles/system-10-link") # Keep by keep-latest-n

    # User profile policy test 1
    # Normal user
    machine.succeed("su normal --command 'nix profile add ${drvForTest "drv1"}'")
    machine.succeed("su normal --command 'nix profile add ${drvForTest "drv2"}'")
    machine.succeed("su normal --command 'nix profile add ${drvForTest "drv3"}'")
    # Root user
    machine.succeed("nix profile add ${drvForTest "drv1"}")
    machine.succeed("nix profile add ${drvForTest "drv2"}")
    machine.succeed("nix profile add ${drvForTest "drv3"}")

    # Run policy
    machine.systemctl("start angrr.service")

    # Test
    machine.succeed("sh -c 'test $(readlink ~normal/.local/state/nix/profiles/profile) = profile-3-link'")
    machine.succeed("test ! -e ~normal/.local/state/nix/profiles/profile-1-link")
    machine.succeed("readlink  ~normal/.local/state/nix/profiles/profile-2-link") # Keep by keep-latest-n
    machine.succeed("readlink  ~normal/.local/state/nix/profiles/profile-3-link") # Keep since it is current generation
    machine.succeed("sh -c 'test $(readlink /nix/var/nix/profiles/per-user/root/profile) = profile-3-link'")
    machine.succeed("test ! -e /nix/var/nix/profiles/per-user/root/profile-1-link")
    machine.succeed("readlink  /nix/var/nix/profiles/per-user/root/profile-2-link") # Keep by keep-latest-n
    machine.succeed("readlink  /nix/var/nix/profiles/per-user/root/profile-3-link") # Keep since it is current generation

    # User profile policy test 2
    # Create GC roots again
    machine.succeed("su normal --command 'nix profile add ${drvForTest "drv1"}'")
    machine.succeed("su normal --command 'nix profile add ${drvForTest "drv2"}'")
    machine.succeed("su normal --command 'nix profile add ${drvForTest "drv3"}'")
    machine.succeed("nix profile add ${drvForTest "drv1"}")
    machine.succeed("nix profile add ${drvForTest "drv2"}")
    machine.succeed("nix profile add ${drvForTest "drv3"}")

    # Run policy in owned-only mode as normal user
    machine.succeed("su normal --command 'angrr run --no-prompt'")

    # Test
    machine.succeed("sh -c 'test $(readlink ~normal/.local/state/nix/profiles/profile) = profile-6-link'")
    machine.succeed("test ! -e ~normal/.local/state/nix/profiles/profile-1-link")
    machine.succeed("test ! -e ~normal/.local/state/nix/profiles/profile-2-link")
    machine.succeed("test ! -e ~normal/.local/state/nix/profiles/profile-3-link")
    machine.succeed("test ! -e ~normal/.local/state/nix/profiles/profile-4-link")
    machine.succeed("readlink  ~normal/.local/state/nix/profiles/profile-5-link") # Keep by keep-latest-n
    machine.succeed("readlink  ~normal/.local/state/nix/profiles/profile-6-link") # Keep since it is current generation
    machine.succeed("sh -c 'test $(readlink /nix/var/nix/profiles/per-user/root/profile) = profile-6-link'")
    machine.succeed("test ! -e /nix/var/nix/profiles/per-user/root/profile-1-link")
    machine.succeed("readlink  /nix/var/nix/profiles/per-user/root/profile-2-link")
    machine.succeed("readlink  /nix/var/nix/profiles/per-user/root/profile-3-link")
    machine.succeed("readlink  /nix/var/nix/profiles/per-user/root/profile-4-link") # Not monitored
    machine.succeed("readlink  /nix/var/nix/profiles/per-user/root/profile-5-link") # Not monitored
    machine.succeed("readlink  /nix/var/nix/profiles/per-user/root/profile-6-link") # Not monitored
  '';
}

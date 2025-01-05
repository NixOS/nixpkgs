import ../make-test-python.nix (
  { pkgs, lib, ... }:
  let
    helloProfileContents = ''
      abi <abi/4.0>,
      include <tunables/global>
      profile hello ${lib.getExe pkgs.hello} {
        include <abstractions/base>
      }
    '';
  in
  {
    name = "apparmor";
    meta.maintainers = with lib.maintainers; [
      julm
      grimmauld
    ];

    nodes.machine =
      {
        lib,
        pkgs,
        config,
        ...
      }:
      {
        security.apparmor = {
          enable = lib.mkDefault true;

          policies.hello = {
            # test profile enforce and content definition
            state = "enforce";
            profile = helloProfileContents;
          };

          policies.sl = {
            # test profile complain and path definition
            state = "complain";
            path = ./sl_profile;
          };

          policies.hexdump = {
            # test profile complain and path definition
            state = "enforce";
            profile = ''
              abi <abi/4.0>,
              include <tunables/global>
              profile hexdump /nix/store/*/bin/hexdump {
                include <abstractions/base>
                deny /tmp/** r,
              }
            '';
          };

          includes."abstractions/base" = ''
            /nix/store/*/bin/** mr,
            /nix/store/*/lib/** mr,
            /nix/store/** r,
          '';
        };
      };

    testScript =
      let
        inherit (lib) getExe getExe';
      in
      ''
        machine.wait_for_unit("multi-user.target")

        with subtest("AppArmor profiles are loaded"):
            machine.succeed("systemctl status apparmor.service")

        # AppArmor securityfs
        with subtest("AppArmor securityfs is mounted"):
            machine.succeed("mountpoint -q /sys/kernel/security")
            machine.succeed("cat /sys/kernel/security/apparmor/profiles")

        # Test apparmorRulesFromClosure by:
        # 1. Prepending a string of the relevant packages' name and version on each line.
        # 2. Sorting according to those strings.
        # 3. Removing those prepended strings.
        # 4. Using `diff` against the expected output.
        with subtest("apparmorRulesFromClosure"):
            machine.succeed(
                "${getExe' pkgs.diffutils "diff"} -u ${
                  pkgs.writeText "expected.rules" (import ./makeExpectedPolicies.nix { inherit pkgs; })
                } ${
                  pkgs.runCommand "actual.rules" { preferLocalBuild = true; } ''
                    ${getExe pkgs.gnused} -e 's:^[^ ]* ${builtins.storeDir}/[^,/-]*-\([^/,]*\):\1 \0:' ${
                      pkgs.apparmorRulesFromClosure {
                        name = "ping";
                        additionalRules = [ "x $path/foo/**" ];
                      } [ pkgs.libcap ]
                    } |
                    ${getExe' pkgs.coreutils "sort"} -n -k1 |
                    ${getExe pkgs.gnused} -e 's:^[^ ]* ::' >$out
                  ''
                }"
            )

        # Test apparmor profile states by using `diff` against `aa-status`
        with subtest("apparmorProfileStates"):
            machine.succeed("${getExe' pkgs.diffutils "diff"} -u \
              <(${getExe' pkgs.apparmor-bin-utils "aa-status"} --json | ${getExe pkgs.jq} --sort-keys . ) \
              <(${getExe pkgs.jq} --sort-keys . ${
                pkgs.writers.writeJSON "expectedStates.json" {
                  version = "2";
                  processes = { };
                  profiles = {
                    hexdump = "enforce";
                    hello = "enforce";
                    sl = "complain";
                  };
                }
              })")

        # Test apparmor profile files in /etc/apparmor.d/<name> to be either a correct symlink (sl) or have the right file contents (hello)
        with subtest("apparmorProfileTargets"):
            machine.succeed("${getExe' pkgs.diffutils "diff"} -u <(${getExe pkgs.file} /etc/static/apparmor.d/sl) ${pkgs.writeText "expected.link" ''
              /etc/static/apparmor.d/sl: symbolic link to ${./sl_profile}
            ''}")
            machine.succeed("${getExe' pkgs.diffutils "diff"} -u /etc/static/apparmor.d/hello ${pkgs.writeText "expected.content" helloProfileContents}")


        with subtest("apparmorProfileEnforce"):
            machine.succeed("${getExe pkgs.hello} 1> /tmp/test-file")
            machine.fail("${lib.getExe' pkgs.util-linux "hexdump"} /tmp/test-file") # no access to /tmp/test-file granted by apparmor
      '';
  }
)

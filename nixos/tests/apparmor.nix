import ./make-test-python.nix ({ pkgs, ... } : {
  name = "apparmor";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ julm ];
  };

  nodes.machine =
    { lib, pkgs, config, ... }:
    with lib;
    {
      security.apparmor.enable = mkDefault true;
    };

  testScript =
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
              "${pkgs.diffutils}/bin/diff ${pkgs.writeText "expected.rules" ''
                  mr ${pkgs.bash}/lib/**.so*,
                  r ${pkgs.bash},
                  r ${pkgs.bash}/etc/**,
                  r ${pkgs.bash}/lib/**,
                  r ${pkgs.bash}/share/**,
                  x ${pkgs.bash}/foo/**,
                  mr ${pkgs.glibc}/lib/**.so*,
                  r ${pkgs.glibc},
                  r ${pkgs.glibc}/etc/**,
                  r ${pkgs.glibc}/lib/**,
                  r ${pkgs.glibc}/share/**,
                  x ${pkgs.glibc}/foo/**,
                  mr ${pkgs.libcap}/lib/**.so*,
                  r ${pkgs.libcap},
                  r ${pkgs.libcap}/etc/**,
                  r ${pkgs.libcap}/lib/**,
                  r ${pkgs.libcap}/share/**,
                  x ${pkgs.libcap}/foo/**,
                  mr ${pkgs.libcap.lib}/lib/**.so*,
                  r ${pkgs.libcap.lib},
                  r ${pkgs.libcap.lib}/etc/**,
                  r ${pkgs.libcap.lib}/lib/**,
                  r ${pkgs.libcap.lib}/share/**,
                  x ${pkgs.libcap.lib}/foo/**,
                  mr ${pkgs.libidn2.out}/lib/**.so*,
                  r ${pkgs.libidn2.out},
                  r ${pkgs.libidn2.out}/etc/**,
                  r ${pkgs.libidn2.out}/lib/**,
                  r ${pkgs.libidn2.out}/share/**,
                  x ${pkgs.libidn2.out}/foo/**,
                  mr ${pkgs.libunistring}/lib/**.so*,
                  r ${pkgs.libunistring},
                  r ${pkgs.libunistring}/etc/**,
                  r ${pkgs.libunistring}/lib/**,
                  r ${pkgs.libunistring}/share/**,
                  x ${pkgs.libunistring}/foo/**,
              ''} ${pkgs.runCommand "actual.rules" { preferLocalBuild = true; } ''
                  ${pkgs.gnused}/bin/sed -e 's:^[^ ]* ${builtins.storeDir}/[^,/-]*-\([^/,]*\):\1 \0:' ${
                      pkgs.apparmorRulesFromClosure {
                        name = "ping";
                        additionalRules = ["x $path/foo/**"];
                      } [ pkgs.libcap ]
                  } |
                  ${pkgs.coreutils}/bin/sort -n -k1 |
                  ${pkgs.gnused}/bin/sed -e 's:^[^ ]* ::' >$out
              ''}"
          )
    '';
})

{ ovn, testers }:

let
  systemTestData = ovn.overrideAttrs {
    doCheck = false;
    outputs = [ "out" ];
    installPhase = "cp -a . $out";
    postInstall = "";
    dontFixup = true;
  };

  mkSystemTest =
    {
      mode,
      makeTarget,
      testSuite,
    }:
    testers.runNixOSTest {
      name = "ovn-system-tests-${mode}";

      nodes.machine = { pkgs, ... }: {
        # These get in the way of some tests.
        networking = {
          firewall.enable = false;
          useDHCP = false;
        };

        environment.systemPackages = with pkgs; [
          bc
          curl
          ethtool
          gnumake
          iproute2
          iputils
          kmod
          net-tools
          nfdump
          nftables
          nmap
          openssl
          procps
          tcpdump
          util-linux
          wget
          which
          (python3.withPackages (ps: [ ps.scapy ]))
        ];
      };

      testScript = ''
        machine.succeed(
            "mkdir -p /build",
            # Makefiles contain absolute references to the build directory.
            "cp -a ${systemTestData} /build/source",
            "chmod -R u+w /build/source",
            r"""
            if ! SKIP_UNSTABLE=yes make -C /build/source ${makeTarget}; then
              echo "Some tests failed. Collecting logs for analysis..."
              find /build/source/tests/${testSuite}.dir -type f \
                -exec echo "==== Contents of {} ====" \; \
                -exec cat {} \;
              exit 1
            fi
            """,
        )
      '';
    };
in
{
  system-userspace = mkSystemTest {
    mode = "userspace";
    makeTarget = "check-system-userspace";
    testSuite = "system-userspace-testsuite";
  };
  system-kernel = mkSystemTest {
    mode = "kernel";
    makeTarget = "check-kernel";
    testSuite = "system-kmod-testsuite";
  };
}

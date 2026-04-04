{
  runTest,
  lib,
  pkgs,
  # Test current default (LTS) and latest kernel
  kernelVersionsToTest ? [
    (lib.versions.majorMinor pkgs.linuxPackages.kernel.version)
    "latest"
  ],
}:

let
  tests =
    let
      callTest =
        p: args:
        runTest {
          imports = [ p ];
          _module = { inherit args; };
        };
    in
    {
      basic = callTest ./basic.nix;
      amneziawg = callTest ./amneziawg.nix;
      namespaces = callTest ./namespaces.nix;
      networkd = callTest ./networkd.nix;
      wg-quick = args: callTest ./wg-quick.nix ({ nftables = false; } // args);
      wg-quick-nftables = args: callTest ./wg-quick.nix ({ nftables = true; } // args);
      amneziawg-quick = args: callTest ./amneziawg-quick.nix ({ nftables = false; } // args);
      generated = callTest ./generated.nix;
      dynamic-refresh = args: callTest ./dynamic-refresh.nix ({ useNetworkd = false; } // args);
      dynamic-refresh-networkd = args: callTest ./dynamic-refresh.nix ({ useNetworkd = true; } // args);
    };
in

lib.listToAttrs (
  lib.flip lib.concatMap kernelVersionsToTest (
    version:
    let
      v' = lib.replaceString "." "_" version;
    in
    lib.flip lib.mapAttrsToList tests (
      name: test:
      lib.nameValuePair "wireguard-${name}-linux-${v'}" (test {
        kernelPackages =
          pkgs: if v' == "latest" then pkgs.linuxPackages_latest else pkgs.linuxKernel.packages."linux_${v'}";
      })
    )
  )
)

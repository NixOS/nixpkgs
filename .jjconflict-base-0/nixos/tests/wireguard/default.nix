{ system ? builtins.currentSystem
, config ? { }
, pkgs ? import ../../.. { inherit system config; }
  # Test current default (LTS) and latest kernel
, kernelVersionsToTest ? [ (pkgs.lib.versions.majorMinor pkgs.linuxPackages.kernel.version) "latest" ]
}:

with pkgs.lib;

let
  tests = let callTest = p: args: import p ({ inherit system pkgs; } // args); in {
    basic = callTest ./basic.nix;
    namespaces = callTest ./namespaces.nix;
    wg-quick = callTest ./wg-quick.nix;
    wg-quick-nftables = args: callTest ./wg-quick.nix ({ nftables = true; } // args);
    generated = callTest ./generated.nix;
  };
in

listToAttrs (
  flip concatMap kernelVersionsToTest (version:
    let
      v' = replaceStrings [ "." ] [ "_" ] version;
    in
    flip mapAttrsToList tests (name: test:
      nameValuePair "wireguard-${name}-linux-${v'}" (test { kernelPackages = pkgs."linuxPackages_${v'}"; })
    )
  )
)

{ system ? builtins.currentSystem
, config ? { }
, pkgs ? import ../../.. { inherit system config; }
, kernelVersionsToTest ? [ "5.4" "latest" ]
}:

with pkgs.lib;

let
  tests = let callTest = p: flip (import p) { inherit system pkgs; }; in {
    basic = callTest ./basic.nix;
    namespaces = callTest ./namespaces.nix;
    wg-quick = callTest ./wg-quick.nix;
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

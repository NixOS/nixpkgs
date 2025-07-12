{
  version ? 4,
  system ? builtins.currentSystem,
  pkgs ? import ../../.. { inherit system; },
}:
{
  simple = import ./simple.nix { inherit version system pkgs; };
}
// pkgs.lib.optionalAttrs (version == 4) {
  # TODO: Test kerberos + nfsv3
  kerberos = import ./kerberos.nix { inherit version system pkgs; };
}

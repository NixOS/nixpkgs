with builtins;

let
  requiredVersion = import ./lib/minver.nix;
  platformPath = {
    x86_64-linux = "/nix/store/mln2lswvkyx6x7j6pcx80cyf06fsc12m-nix-1.11.2";
    i686-linux = "/nix/store/fpa7k4ra0jcy1jq3cig5738dmmqsqyjc-nix-1.11.2";
    x86_64-darwin = "/nix/store/mcfhmajqw93xs4bgk55822gag11qs7yk-nix-1.11.2";
  };
  installMsg = if (hasAttr currentSystem platformPath) then ''
    On your platform ${currentSystem}:

      $ nix-env -i ${getAttr currentSystem platformPath}
  '' else ''
    Your platform ${currentSystem} doesn't have a binary cache. Please
    reinstall Nix following instructions on http://nixos.org/nix/download.html
  '';
in


if ! builtins ? nixVersion || builtins.compareVersions requiredVersion builtins.nixVersion == 1 then

# following derivations are updated based on http://hydra.nixos.org/jobset/nix/maintenance/latest-eval

  abort ''
  This version of Nixpkgs requires Nix >= ${requiredVersion}, please upgrade:

  ${installMsg}''

else

  import ./pkgs/top-level/impure.nix

let requiredVersion = import ./lib/minver.nix; in

if ! builtins ? nixVersion || builtins.compareVersions requiredVersion builtins.nixVersion == 1 then

# following derivations are updated based on http://hydra.nixos.org/jobset/nix/maintenance/latest-eval

  abort ''
  This version of Nixpkgs requires Nix >= ${requiredVersion}, please upgrade:

  On x86_64-linux:

    $ nix-env -i /nix/store/mln2lswvkyx6x7j6pcx80cyf06fsc12m-nix-1.11.2

  On i686-linux:

    $ nix-env -i /nix/store/fpa7k4ra0jcy1jq3cig5738dmmqsqyjc-nix-1.11.2

  On x86_64-darwin:

    $ nix-env -i /nix/store/mcfhmajqw93xs4bgk55822gag11qs7yk-nix-1.11.2
  ''

else

  import ./pkgs/top-level/impure.nix

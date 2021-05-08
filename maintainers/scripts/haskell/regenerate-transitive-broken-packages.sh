#! /usr/bin/env nix-shell
#! nix-shell -i bash -p coreutils nix gnused -I nixpkgs=.
echo -e $(nix-instantiate --eval --strict maintainers/scripts/haskell/transitive-broken-packages.nix) | sed 's/\"//' > pkgs/development/haskell-modules/configuration-hackage2nix/transitive-broken.yaml

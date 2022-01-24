# Nix script to lookup maintainer github handles from their email address. Used by ./hydra-report.hs.
let
  pkgs = import ../../.. {};
  maintainers = import ../../maintainer-list.nix;
  inherit (pkgs) lib;
  mkMailGithubPair = _: maintainer: if maintainer ? github then { "${maintainer.email}" = maintainer.github; } else {};
in lib.zipAttrsWith (_: builtins.head) (lib.mapAttrsToList mkMailGithubPair maintainers)

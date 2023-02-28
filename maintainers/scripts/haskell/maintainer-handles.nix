# Nix script to lookup maintainer github handles from their email address. Used by ./hydra-report.hs.
#
# This script produces an attr set mapping of email addresses to GitHub handles:
#
# ```nix
# > import ./maintainer-handles.nix
# { "cdep.illabout@gmail.com" = "cdepillabout"; "john@smith.com" = "johnsmith"; ... }
# ```
#
# This mapping contains all maintainers in ../../mainatainer-list.nix, but it
# ignores maintainers who don't have a GitHub account or an email address.
let
  pkgs = import ../../.. {};
  maintainers = import ../../maintainer-list.nix;
  inherit (pkgs) lib;
  mkMailGithubPair = _: maintainer:
    if (maintainer ? email) && (maintainer ? github) then
      { "${maintainer.email}" = maintainer.github; }
    else
      {};
in lib.zipAttrsWith (_: builtins.head) (lib.mapAttrsToList mkMailGithubPair maintainers)

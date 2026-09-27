{
  writeText,
  writers,
  lib,
  fromDir,
}:
# Creates a derivation from various formats compatible with the TOML spec expected by kalamine
layout:
# Can be either an actual TOML file, a derivation building a TOML file (like `fetchurl { url = ".../file.toml"; ...}`),
# a TOML string, or a nix attrset representing a TOML file
# All must be parseable by kalamine.
let
  attributes =
    if
      (
        ((builtins.isString layout && lib.hasPrefix "/" layout) || builtins.isPath layout)
        && (builtins.pathExists layout)
      )
      || lib.isDerivation layout
    then # TOML file case; `pathExists` because it accepts both strings and paths
      let
        layoutFile = if lib.isDerivation layout then "${layout}" else layout; # we expect a path always
      in
      {
        tomlFile = layoutFile;
        parsedLayout = fromTOML (builtins.readFile layoutFile);
      }
    else if builtins.isString layout then # TOML string case
      let
        parsedLayout = fromTOML layout;
      in
      {
        tomlFile = writeText "${parsedLayout.name8 or "kalamine"}-layout.toml" layout;
        inherit parsedLayout;
      }
    else if builtins.isAttrs layout then # Attrset case
      {
        parsedLayout = layout;
        tomlFile = writers.writeTOML "${layout.name8 or "kalamine"}-layout.toml" layout;
      }
    else
      throw "The layout must be either a valid TOML file, a valid TOML string, or an attrset; all valid for kalamine to use.";
  inherit (attributes) tomlFile parsedLayout;
in
{
  name ? null,
  pname ? parsedLayout.name8 or null,
  version ? parsedLayout.version or null,
  description ? parsedLayout.description or null,
  homepage ? parsedLayout.url or null,
  args ? null, # kalamineBuildArgs
  extraDerivationArgs ? { },
  name8 ? parsedLayout.name8 or null,
}:
fromDir tomlFile {
  inherit
    name
    pname
    version
    description
    homepage
    args
    extraDerivationArgs
    name8
    ;
  dontUnpack = true;
}

{
  lib,
  buildVimPlugin,
  fetchFromGitHub,
  luaPackages,
}:
let
  stripDate = builtins.substring 0 10;
  parseLicense =
    license:
    # NOASSERTION means unknown license
    if license == null || license == "NOASSERTION" then
      { }
    else if license == "AGPL-3.0" then
      { license = lib.licenses.agpl3Only; }
    else
      { license = lib.licensesSpdx.${license}; };
in
builtins.mapAttrs (
  name: plugin:
  let
    pname = if plugin.info.alias != null then plugin.info.alias else plugin.info.repo.name;
  in
  assert lib.assertMsg (!(luaPackages ? ${pname}))
    "This package is already packaged in luaPackages, please use it instead.\n(just add the package name to the end of overrides.nix)";
  buildVimPlugin {
    inherit pname;
    version = "0-${stripDate plugin.fetched.commit.date}";

    src =
      assert plugin.nurl_result.fetcher == "fetchFromGitHub";
      fetchFromGitHub plugin.nurl_result.args;
    meta =
      with plugin.fetched.meta;
      {
        hydraPlatforms = [ ];
      }
      // lib.optionalAttrs (description != null) { inherit description; }
      // lib.optionalAttrs (homepage != null) { inherit homepage; }
      // parseLicense license;
  }
) (builtins.fromJSON (builtins.readFile ./generated.json))

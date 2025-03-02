{
  lib,
  buildVimPlugin,
  fetchFromGitHub,
  luaPackages,
}:
let
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
  pname: plugin:
  assert lib.assertMsg (!(luaPackages ? ${pname}))
    "This package is already packaged in luaPackages, please use it instead.\n(just add the package name to the end of overrides.nix)";
  buildVimPlugin {
    inherit pname;
    inherit (plugin) version;

    src =
      assert plugin.nurl_result.fetcher == "fetchFromGitHub";
      fetchFromGitHub plugin.nurl_result.args;
    meta =
      with plugin;
      {
        hydraPlatforms = [ ];
      }
      // lib.optionalAttrs (description != null) { inherit description; }
      // lib.optionalAttrs (homepage != null) { inherit homepage; }
      // parseLicense license;
  }
) (builtins.fromJSON (builtins.readFile ./generated.json))

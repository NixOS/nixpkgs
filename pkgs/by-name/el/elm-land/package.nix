{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  fetchpatch,
  elmPackages,
  versionCheckHook,
  writeShellScript,
  nix-update,
  elm2nix,
  nixfmt,
}:

let
  version = "0.20.1";
  src = fetchFromGitHub {
    owner = "elm-land";
    repo = "elm-land";
    rev = "v${version}";
    hash = "sha256-PFyiVTH2Cek377YZwaCmvDToQCaxWQvJrQkRhyNI2Wg=";
  };
  cliSubdir = "projects/cli";

in

buildNpmPackage {
  pname = "elm-land";

  inherit version src;

  sourceRoot = "${src.name}/${cliSubdir}";

  npmDepsHash = "sha256-yb/TEw8QdGigRzu2VHBvGBoUrbq06xU3igkOBfKBm+A=";

  npmRebuildFlags = [ "--ignore-scripts" ];

  postConfigure =
    (elmPackages.fetchElmDeps {
      elmPackages = import ./elm-srcs.nix;
      elmVersion = elmPackages.elm.version;
      registryDat = ./registry.dat;
    })
    + ''
      ln -sf ${lib.getExe elmPackages.elm} node_modules/.bin/elm
    '';

  patches = [
    (fetchpatch {
      # TODO change to elm-land/elm-land once discord PR pre-flight process is complete
      url = "https://github.com/jerith666/elm-land/commit/f37535cd054323e3d05e0ff10bd1356f7a3ccd92.patch";
      hash = "sha256-y20LNwPdZcJ/vPPwPBox4mw2pgxNZg5DYLEa7ErEXB4=";
      relative = cliSubdir;
    })
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = writeShellScript "update-elm-land" ''
    set -eu -o pipefail

    # Update version, src and npm deps
    ${lib.getExe nix-update} "$UPDATE_NIX_ATTR_PATH"

    # Update elm deps
    cp "$(nix-build -A "$UPDATE_NIX_ATTR_PATH".src)/projects/cli/src/codegen/elm.json" elm.json
    trap 'rm -rf elm.json registry.dat &> /dev/null' EXIT
    ${lib.getExe elm2nix} convert > pkgs/by-name/el/elm-land/elm-srcs.nix
    ${lib.getExe nixfmt} pkgs/by-name/el/elm-land/elm-srcs.nix
    ${lib.getExe elm2nix} snapshot
    cp registry.dat pkgs/by-name/el/elm-land/registry.dat
  '';

  meta = {
    description = "Production-ready framework for building Elm applications";
    homepage = "https://github.com/elm-land/elm-land";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      zupo
    ];
    mainProgram = "elm-land";
  };
}

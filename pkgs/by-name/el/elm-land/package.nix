{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  elmPackages,
  versionCheckHook,
  writeShellScript,
  nix-update,
  elm2nix,
  nixfmt,
}:

buildNpmPackage rec {
  pname = "elm-land";
  version = "0.20.1";

  src = fetchFromGitHub {
    owner = "elm-land";
    repo = "elm-land";
    rev = "v${version}";
    hash = "sha256-PFyiVTH2Cek377YZwaCmvDToQCaxWQvJrQkRhyNI2Wg=";
  };

  sourceRoot = "${src.name}/projects/cli";

  npmDepsHash = "sha256-Bg16s0tqEaUT+BbFMKuEtx32rmbZLIILp8Ra/dQGmUg=";

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

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
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

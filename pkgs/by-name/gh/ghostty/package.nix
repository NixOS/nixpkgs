{
  lib,
  ghostty-unwrapped,
  makeBinaryWrapper,
  symlinkJoin,
  versionCheckHook,
  wrapGAppsHook4,
}:

symlinkJoin rec {
  inherit (ghostty-unwrapped) pname version outputs;

  paths = [ ghostty-unwrapped ];

  nativeBuildInputs = [
    makeBinaryWrapper
    versionCheckHook
    wrapGAppsHook4
  ];

  versionCheckProgramArg = [ "--version" ];

  postBuild = ''
    wrapGAppsHook
    versionCheckHook
  ''
  # Link back to the unwrapped package's split outputs
  + lib.concatLines (
    map (output: "ln -s ${ghostty-unwrapped.${output}} \$${output}") (lib.remove "out" outputs)
  );

  passthru = {
    unwrapped = ghostty-unwrapped;

    inherit (passthru.unwrapped) tests;
    updateScript = ./update.nu;
  };

  meta = {
    inherit (ghostty-unwrapped.meta)
      description
      longDescription
      homepage
      downloadPage
      changelog
      license
      mainProgram
      maintainers
      outputsToInstall
      platforms
      ;
  };
}

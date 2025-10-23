{
  lib,
  formats,
  ghostty-unwrapped,
  ghostty,
  makeBinaryWrapper,
  symlinkJoin,
  versionCheckHook,
  wrapGAppsHook4,
  settings ? { },
}:

symlinkJoin rec {
  inherit (ghostty-unwrapped) pname version outputs;

  paths = [ ghostty-unwrapped ];

  nativeBuildInputs = [
    makeBinaryWrapper
    versionCheckHook
    wrapGAppsHook4
  ];

  makeWrapperArgs = lib.optionals (settings != { }) [
    "--add-flags"
    "--config-file=${passthru.configurationFile}"
  ];

  versionCheckProgramArg = [ "--version" ];

  postBuild = ''
    concatTo makeWrapperArgsArray makeWrapperArgs gappsWrapperArgs
    wrapProgram $out/bin/ghostty "''${makeWrapperArgsArray[@]}"
    versionCheckHook
    $out/bin/ghostty +validate-config
  ''
  # Link back to the unwrapped package's split outputs
  + lib.concatLines (
    map (output: "ln -s ${ghostty-unwrapped.${output}} \$${output}") (lib.remove "out" outputs)
  );

  passthru = {
    unwrapped = ghostty-unwrapped;

    configurationFileFormat = formats.keyValue {
      listsAsDuplicateKeys = true;
      mkKeyValue = lib.generators.mkKeyValueDefault { } " = ";
    };

    tests = lib.recursiveUpdate passthru.unwrapped.tests {
      wrapper = ghostty.override {
        settings = {
          theme = "Gruvbox Dark";
        };
      };
    };

    updateScript = ./update.nu;
  }
  // lib.optionalAttrs (settings != { }) {
    configurationFile = passthru.configurationFileFormat.generate "ghostty-config" settings;
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

{
  lib,
  stdenv,
  formats,
  ghostty-unwrapped,
  makeBinaryWrapper,
  nixosTests,
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
  ] ++ lib.optionals (ghostty-unwrapped.appRuntime == "gtk") [ wrapGAppsHook4 ];

  makeWrapperArgs = lib.optionals (settings != { }) [
    "--add-flags"
    "--config-file=${passthru.configurationFile}"
  ];

  versionCheckProgramArg = [ "--version" ];

  postBuild =
    ''
      concatTo makeWrapperArgsArray makeWrapperArgs gappsWrapperArgs
      wrapProgram $out/bin/ghostty "''${makeWrapperArgsArray[@]}"
      versionCheckHook
    ''
    # Link back to the unwrapped package's split outputs
    + lib.concatLines (
      map (output: "ln -s ${ghostty-unwrapped.${output}} \$${output}") (
        lib.remove "out" ghostty-unwrapped.outputs
      )
    );

  passthru =
    {
      inherit ghostty-unwrapped;

      configurationFileFormat = formats.keyValue {
        listsAsDuplicateKeys = true;
        mkKeyValue = lib.generators.mkKeyValueDefault { } " = ";
      };

      tests = lib.optionalAttrs stdenv.hostPlatform.isLinux {
        inherit (nixosTests) allTerminfo;
        nixos = nixosTests.terminal-emulators.ghostty;
      };
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
      broken
      ;
  };
}

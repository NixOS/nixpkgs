{
  lib,
  stdenv,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  autoPatchelfHook,
  copyDesktopItems,
  icu,
  openssl,
  libkrb5,
  makeDesktopItem,
  writeShellScript,
  nix-update,
}:
buildDotnetModule (finalAttrs: rec {
  pname = "msbuild-structured-log-viewer";
  version = "2.2.392";

  src = fetchFromGitHub {
    owner = "KirillOsenkov";
    repo = "MSBuildStructuredLog";
    rev = "v${version}";
    hash = "sha256-oMWFgELF/bIDQWOdrBAOLTluwH3rFO2vU0xCuRnrT1Y=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  projectFile = [ "src/StructuredLogViewer.Avalonia/StructuredLogViewer.Avalonia.csproj" ];
  nugetDeps = ./deps.nix;

  # HACK: Clear out RuntimeIdentifiers that's set in StructuredLogViewer.Avalonia.csproj, otherwise our --runtime has no effect
  dotnetFlags = [ "-p:RuntimeIdentifiers=" ];

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
    copyDesktopItems
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    stdenv.cc.cc.lib
    icu
    openssl
    libkrb5
  ];

  dontDotnetFixup = true;

  postFixup =
    ''
      wrapDotnetProgram $out/lib/${finalAttrs.pname}/StructuredLogViewer.Avalonia $out/bin/${meta.mainProgram}
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      install -Dm444 $src/src/StructuredLogViewer/icons/msbuild-structured-log-viewer.png $out/share/icons/hicolor/32x32/apps/${finalAttrs.pname}.png
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace src/StructuredLogViewer.Avalonia/Info.plist \
        --replace-fail "0.0.1" "${finalAttrs.version}"

      install -Dm444 src/StructuredLogViewer.Avalonia/Info.plist $out/Applications/StructuredLogViewer.app/Contents/Info.plist
      install -Dm444 src/StructuredLogViewer.Avalonia/StructuredLogViewer.icns $out/Applications/StructuredLogViewer.app/Contents/Resources/StructuredLogViewer.icns
      mkdir -p $out/Applications/StructuredLogViewer.app/Contents/MacOS
      ln -s $out/bin/${meta.mainProgram} $out/Applications/StructuredLogViewer.app/Contents/MacOS/StructuredLogViewer.Avalonia
    '';

  desktopItems = makeDesktopItem {
    name = finalAttrs.pname;
    desktopName = "MSBuild Structured Log Viewer";
    comment = finalAttrs.meta.description;
    icon = finalAttrs.pname;
    exec = meta.mainProgram;
    categories = [ "Development" ];
  };

  passthru.updateScript = writeShellScript "update-${finalAttrs.pname}" ''
    ${lib.getExe nix-update}
    "$(nix-build -A "$UPDATE_NIX_ATTR_PATH.fetch-deps" --no-out-link)"
  '';

  meta = {
    description = "Rich interactive log viewer for MSBuild logs";
    homepage = "https://github.com/KirillOsenkov/MSBuildStructuredLog";
    changelog = "https://github.com/KirillOsenkov/MSBuildStructuredLog/releases/tag/v${finalAttrs.version}";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
      binaryNativeCode
    ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ js6pak ];
    mainProgram = "msbuild-structured-log-viewer";
  };
})

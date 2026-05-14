{
  lib,
  stdenv,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  writeText,
  copyDesktopItems,
  makeDesktopItem,
  nix-update-script,
}:
buildDotnetModule (finalAttrs: {
  pname = "msbuild-structured-log-viewer";
  version = "2.3.150";

  src = fetchFromGitHub {
    owner = "KirillOsenkov";
    repo = "MSBuildStructuredLog";
    rev = "v${finalAttrs.version}";
    hash = "sha256-HTWPsVl/pMi+lMSax5JNtbPXHeqD8QxfvLp2bhVxfPs=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  projectFile = [ "src/StructuredLogViewer.Avalonia/StructuredLogViewer.Avalonia.csproj" ];
  nugetDeps = ./deps.json;

  dotnetBuildFlags = [
    "-p:CustomAfterDirectoryBuildTargets=${writeText "StubGitVersioning.targets" ''
      <Project>
          <Target Name="GetBuildVersion" Returns="$(BuildVersion)" DependsOnTargets="GetAssemblyVersion">
              <PropertyGroup>
                  <BuildVersion>$(Version)</BuildVersion>
                  <AssemblyFileVersion>$(FileVersion)</AssemblyFileVersion>
                  <AssemblyInformationalVersion>$(InformationalVersion)</AssemblyInformationalVersion>
              </PropertyGroup>
          </Target>
      </Project>
    ''}"
  ];

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    copyDesktopItems
  ];

  dontDotnetFixup = true;

  postFixup = ''
    wrapDotnetProgram $out/lib/msbuild-structured-log-viewer/StructuredLogViewer.Avalonia $out/bin/${finalAttrs.meta.mainProgram}
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm444 $src/src/StructuredLogViewer/icons/msbuild-structured-log-viewer.png $out/share/icons/hicolor/32x32/apps/msbuild-structured-log-viewer.png
    install -Dm444 ${./mimetype.xml} $out/share/mime/packages/binlog.xml
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace src/StructuredLogViewer.Avalonia/Info.plist \
      --replace-fail "0.0.1" "${finalAttrs.version}"

    install -Dm444 src/StructuredLogViewer.Avalonia/Info.plist $out/Applications/StructuredLogViewer.app/Contents/Info.plist
    install -Dm444 src/StructuredLogViewer.Avalonia/StructuredLogViewer.icns $out/Applications/StructuredLogViewer.app/Contents/Resources/StructuredLogViewer.icns
    mkdir -p $out/Applications/StructuredLogViewer.app/Contents/MacOS
    ln -s $out/bin/${finalAttrs.meta.mainProgram} $out/Applications/StructuredLogViewer.app/Contents/MacOS/StructuredLogViewer.Avalonia
  '';

  desktopItems = makeDesktopItem {
    name = "msbuild-structured-log-viewer";
    desktopName = "MSBuild Structured Log Viewer";
    comment = finalAttrs.meta.description;
    icon = "msbuild-structured-log-viewer";
    exec = finalAttrs.meta.mainProgram;
    categories = [ "Development" ];
    mimeTypes = [
      "application/x-binlog"
    ];
  };

  passthru.updateScript = nix-update-script { };

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

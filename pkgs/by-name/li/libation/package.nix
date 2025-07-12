{
  lib,
  stdenv,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  wrapGAppsHook3,
  glew,
  gtk3,
  xorg,
}:

buildDotnetModule rec {
  pname = "libation";
  version = "12.3.1";

  src = fetchFromGitHub {
    owner = "rmcrackan";
    repo = "Libation";
    tag = "v${version}";
    hash = "sha256-jir1r78HbAhlOiCj6pSw0+o4V9ceCkJQWnKtt6VzLDY=";
  };

  sourceRoot = "${src.name}/Source";

  dotnet-sdk = dotnetCorePackages.sdk_9_0;

  dotnet-runtime = dotnetCorePackages.runtime_9_0;

  nugetDeps = ./deps.json;

  dotnetFlags = [
    "-p:PublishReadyToRun=false"
    # for some reason this is set to win-x64 in the project files
    "-p:RuntimeIdentifier="
  ];

  projectFile = [
    "LibationAvalonia/LibationAvalonia.csproj"
    "LibationCli/LibationCli.csproj"
    "HangoverAvalonia/HangoverAvalonia.csproj"
  ];

  nativeBuildInputs = [ wrapGAppsHook3 ];

  runtimeDeps = [
    # For Avalonia UI
    glew
    xorg.libXrandr
    xorg.libXi
    xorg.libXcursor
    # For file dialogs
    gtk3
  ];

  postInstall = ''
    install -Dm644 LoadByOS/LinuxConfigApp/libation_glass.svg $out/share/icons/hicolor/scalable/apps/libation.svg
    install -Dm644 LoadByOS/LinuxConfigApp/Libation.desktop $out/share/applications/libation.desktop
    substituteInPlace $out/share/applications/libation.desktop \
      --replace-fail "/usr/bin/libation" "libation"
  '';

  # wrap manually, because we need lower case executables
  dontDotnetFixup = true;

  preFixup = ''
    # remove binaries for other platform, like upstream does
    pushd $out/lib/libation
    rm -f *.x86.dll *.x64.dll
    ${lib.optionalString (stdenv.system != "x86_64-linux") "rm -f *.x64.so"}
    ${lib.optionalString (stdenv.system != "aarch64-linux") "rm -f *.arm64.so"}
    ${lib.optionalString (stdenv.system != "x86_64-darwin") "rm -f *.x64.dylib"}
    ${lib.optionalString (stdenv.system != "aarch64-darwin") "rm -f *.arm64.dylib"}
    popd

    wrapDotnetProgram $out/lib/libation/Libation $out/bin/libation
    wrapDotnetProgram $out/lib/libation/LibationCli $out/bin/libationcli
    wrapDotnetProgram $out/lib/libation/Hangover $out/bin/hangover
  '';

  meta = {
    changelog = "https://github.com/rmcrackan/Libation/releases/tag/v${version}";
    description = "Audible audiobook manager";
    homepage = "https://github.com/rmcrackan/Libation";
    license = lib.licenses.gpl3Plus;
    mainProgram = "libation";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}

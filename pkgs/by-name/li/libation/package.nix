{
  lib,
  stdenv,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  wrapGAppsHook3,

  glew,
  gtk3,
}:

buildDotnetModule rec {
  pname = "libation";
  version = "11.5.5";

  src = fetchFromGitHub {
    owner = "rmcrackan";
    repo = "Libation";
    rev = "v${version}";
    hash = "sha256-FD3f2Cba1xN15BloyRQ/m/vDovhN8x0AlfeJk+LGVV4=";
  };

  sourceRoot = "${src.name}/Source";

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

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
    # For file dialogs
    gtk3
  ];

  postInstall = ''
    install -Dm644 LoadByOS/LinuxConfigApp/libation_glass.svg $out/share/icons/hicolor/scalable/apps/libation.svg
    install -Dm644 LoadByOS/LinuxConfigApp/Libation.desktop $out/share/applications/libation.desktop
    substituteInPlace $out/share/applications/libation.desktop \
        --replace-fail "/usr/bin/libation" "${meta.mainProgram}"
  '';

  # wrap manually, because we need lower case excutables
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
    changelog = "https://github.com/rmcrackan/Libation/releases/tag/${src.rev}";
    description = "Audible audiobook manager";
    homepage = "https://github.com/rmcrackan/Libation";
    license = lib.licenses.gpl3Only;
    mainProgram = "libation";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}

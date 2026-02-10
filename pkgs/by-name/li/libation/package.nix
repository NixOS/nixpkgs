{
  lib,
  stdenv,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  wrapGAppsHook3,
  glew,
  gtk3,
  libxrandr,
  libxi,
  libxcursor,
  nix-update-script,
}:

buildDotnetModule rec {
  pname = "libation";
  version = "13.1.8";

  src = fetchFromGitHub {
    owner = "rmcrackan";
    repo = "Libation";
    tag = "v${version}";
    hash = "sha256-FDBUnGmMUuMrFvit/QgaZKF+X8u/vp/9muOpRYXFUW4=";
  };

  sourceRoot = "${src.name}/Source";

  dotnet-sdk = dotnetCorePackages.sdk_10_0;

  dotnet-runtime = dotnetCorePackages.runtime_10_0;

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
    libxrandr
    libxi
    libxcursor
    # For file dialogs
    gtk3
  ];

  postInstall = ''
    install -Dm644 LoadByOS/LinuxConfigApp/libation_glass.svg $out/share/icons/hicolor/scalable/apps/libation.svg
    install -Dm644 LoadByOS/LinuxConfigApp/Libation.desktop $out/share/applications/libation.desktop
  '';

  # wrap manually, because we need lower case executables
  dontDotnetFixup = true;

  preFixup = ''
    wrapDotnetProgram $out/lib/libation/Libation $out/bin/libation
    wrapDotnetProgram $out/lib/libation/LibationCli $out/bin/libationcli
    wrapDotnetProgram $out/lib/libation/Hangover $out/bin/hangover
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/rmcrackan/Libation/releases/tag/v${version}";
    description = "Audible audiobook manager";
    homepage = "https://github.com/rmcrackan/Libation";
    license = lib.licenses.gpl3Plus;
    mainProgram = "libation";
    maintainers = with lib.maintainers; [
      tomasajt
      tebriel
    ];
  };
}

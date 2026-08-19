{
  lib,
  fetchFromGitHub,
  alsa-lib,
  buildDotnetModule,
  dotnetCorePackages,
  glib,
  libGL,
  libmpg123,
  libsndfile,
  libxkbcommon,
  pipewire,
  wayland,
  nix-update-script,
}:

buildDotnetModule (finalAttrs: {
  pname = "helion";
  version = "1.0.0.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Helion-Engine";
    repo = "Helion";
    tag = finalAttrs.version;
    hash = "sha256-04RGAoqWwxvtijZIHYZz+V6wgJ0OKuKPLdAbJa+Ol+s=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;

  projectFile = "Client/Client.csproj";
  nugetDeps = ./deps.json;

  executables = [ "Helion" ];

  runtimeDeps = [
    alsa-lib
    glib
    libGL
    libmpg123
    libsndfile
    libxkbcommon
    pipewire
    wayland
  ];

  doCheck = true;
  testProjectFile = "Tests/Tests.csproj";

  postInstall = ''
    install -Dm444 Assets/Misc/Helion.desktop -t $out/share/applications
    install -Dm444 Assets/Misc/helion.svg $out/share/icons/hicolor/scalable/apps/Helion.svg
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^([0-9.]+)$"
    ];
  };

  meta = {
    description = "Modern, fast-paced Doom FPS engine";
    longDescription = ''
      Helion is a Doom source port written in C# with a focus on performance. It
      renders statically with a state management system to reconcile dynamic map
      changes instead of walking the BSP tree, which makes very large maps
      playable. It supports WADs targeting vanilla, Boom, MBF, MBF21, ID24 and
      (partially) UDMF, and requires an OpenGL 3.3 capable GPU.
    '';
    homepage = "https://github.com/Helion-Engine/Helion";
    changelog = "https://github.com/Helion-Engine/Helion/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ keenanweaver ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "Helion";
  };
})

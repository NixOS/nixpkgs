{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  libX11,
  libgdiplus,
  ffmpeg,
  openal,
  libsoundio,
  sndio,
  pulseaudio,
  vulkan-loader,
  glew,
  libGL,
  libICE,
  libSM,
  libXcursor,
  libXext,
  libXi,
  libXrandr,
  udev,
  SDL2,
  SDL2_mixer,
}:

let
  tag = "r.49574a9";
in
buildDotnetModule {
  pname = "ryujinx-mirror";
  version = "0-unstable-2024-10-23";

  src = fetchFromGitHub {
    owner = "ryujinx-mirror";
    repo = "ryujinx";
    rev = "refs/tags/${tag}";
    hash = "sha256-UALAWXc4d1dD/ZFuIIxq9YBreSMc5BIpWf0Bhq7pheM=";
  };

  # parallel building causes failure where files are accessed by multiple
  # processes simultaneously
  enableParallelBuilding = false;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  nugetDeps = ./deps.nix;

  runtimeDeps = [
    libX11
    libgdiplus
    SDL2_mixer
    openal
    libsoundio
    sndio
    pulseaudio
    vulkan-loader
    ffmpeg
    udev

    # Avalonia UI
    glew
    libICE
    libSM
    libXcursor
    libXext
    libXi
    libXrandr

    # Headless executable
    libGL
    SDL2
  ];

  projectFile = "Ryujinx.sln";
  testProjectFile = "src/Ryujinx.Tests/Ryujinx.Tests.csproj";
  doCheck = true;

  dotnetFlags = [
    "/p:ExtraDefineConstants=DISABLE_UPDATER%2CFORCE_EXTERNAL_BASE_DIR"
  ];

  executables = [
    "Ryujinx.Headless.SDL2"
    "Ryujinx"
  ];

  makeWrapperArgs = [
    # Without this Ryujinx fails to start on wayland.
    "--set SDL_VIDEODRIVER x11"
  ];

  preInstall = ''
    # workaround for https://github.com/Ryujinx/Ryujinx/issues/2349
    mkdir -p $out/lib/sndio-6
    ln -s ${sndio}/lib/libsndio.so $out/lib/sndio-6/libsndio.so.6
  '';

  preFixup = ''
    mkdir -p $out/share/{applications,icons/hicolor/scalable/apps,mime/packages}
    pushd ./distribution/linux

    install -D ./Ryujinx.desktop $out/share/applications/Ryujinx.desktop
    install -D ./Ryujinx.sh $out/bin/Ryujinx.sh
    install -D ./mime/Ryujinx.xml $out/share/mime/packages/Ryujinx.xml
    install -D ../misc/Logo.svg $out/share/icons/hicolor/scalable/apps/Ryujinx.svg

    ln -s $out/bin/Ryujinx $out/bin/ryujinx

    popd
  '';

  meta = with lib; {
    homepage = "https://github.com/ryujinx-mirror/ryujinx";
    changelog = "https://github.com/ryujinx-mirror/ryujinx/releases/tag/${tag}";
    description = "Maintenance hard fork of the experimental Nintendo Switch Emulator written in C#";
    longDescription = ''
      Ryujinx is an open-source Nintendo Switch emulator, created by gdkchan,
      written in C#. The ryujinx-mirror/ryujinx repository serves as a
      downstream hard fork of the original Ryujinx project, focused on small
      fixes and infrastructure reconstruction, staying more true to the original
      Ryujinx project.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [
      jk
      artemist
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "Ryujinx";
  };
}

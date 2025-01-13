{
  lib,
  buildDotnetModule,
  cctools,
  darwin,
  dotnetCorePackages,
  fetchFromGitHub,
  libX11,
  libgdiplus,
  moltenvk,
  ffmpeg,
  openal,
  libsoundio,
  sndio,
  stdenv,
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

buildDotnetModule rec {
  pname = "ryujinx-greemdev";
  version = "1.2.76";

  src = fetchFromGitHub {
    owner = "GreemDev";
    repo = "Ryujinx";
    rev = version;
    hash = "sha256-RQbFN+XMEZtouUB7cvO3OdanUm6Is9V2L6q7dqzGQY4=";
  };

  nativeBuildInputs = lib.optional stdenv.isDarwin [
    cctools
    darwin.sigtool
  ];

  enableParallelBuilding = false;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  nugetDeps = ./deps.json;

  runtimeDeps =
    [
      libX11
      libgdiplus
      SDL2_mixer
      openal
      libsoundio
      sndio
      vulkan-loader
      ffmpeg

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
    ]
    ++ lib.optional (!stdenv.isDarwin) [
      udev
      pulseaudio
    ]
    ++ lib.optional stdenv.isDarwin [ moltenvk ];

  projectFile = "Ryujinx.sln";
  testProjectFile = "src/Ryujinx.Tests/Ryujinx.Tests.csproj";

  # Tests on Darwin currently fail because of Ryujinx.Tests.Unicorn
  doCheck = !stdenv.isDarwin;

  dotnetFlags = [
    "/p:ExtraDefineConstants=DISABLE_UPDATER%2CFORCE_EXTERNAL_BASE_DIR"
  ];

  executables = [
    "Ryujinx.Headless.SDL2"
    "Ryujinx"
  ];

  makeWrapperArgs = [
    # Without this Ryujinx fails to start on wayland. See https://github.com/Ryujinx/Ryujinx/issues/2714
    "--set SDL_VIDEODRIVER x11"
  ];

  preInstall = ''
    # workaround for https://github.com/Ryujinx/Ryujinx/issues/2349
    mkdir -p $out/lib/sndio-6
    ln -s ${sndio}/lib/libsndio.so $out/lib/sndio-6/libsndio.so.6
  '';

  preFixup = ''
    ${lib.optionalString stdenv.isLinux ''
      mkdir -p $out/share/{applications,icons/hicolor/scalable/apps,mime/packages}

      pushd ${src}/distribution/linux

      install -D ./Ryujinx.desktop  $out/share/applications/Ryujinx.desktop
      install -D ./Ryujinx.sh       $out/bin/Ryujinx.sh
      install -D ./mime/Ryujinx.xml $out/share/mime/packages/Ryujinx.xml
      install -D ../misc/Logo.svg   $out/share/icons/hicolor/scalable/apps/Ryujinx.svg

      popd
    ''}

    # Don't make a softlink on OSX because of its case insensitivity
    ${lib.optionalString (!stdenv.isDarwin) "ln -s $out/bin/Ryujinx $out/bin/ryujinx"}
  '';

  passthru.updateScript = ./updater.sh;

  meta = with lib; {
    homepage = "https://github.com/GreemDev/Ryujinx";
    changelog = "https://github.com/GreemDev/Ryujinx/wiki/Changelog";
    description = "Experimental Nintendo Switch Emulator written in C# (QoL fork)";
    longDescription = ''
      Ryujinx is an open-source Nintendo Switch emulator, created by gdkchan,
      written in C#. This emulator aims at providing excellent accuracy and
      performance, a user-friendly interface and consistent builds. It was
      written from scratch and development on the project began in September
      2017. The project has since been abandoned on October 1st 2024 and QoL
      updates are now managed under a fork.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [
      jk
      artemist
      kekschen
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "Ryujinx";
  };
}

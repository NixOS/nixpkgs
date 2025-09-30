{
  lib,
  buildDotnetModule,
  cctools,
  darwin,
  dotnetCorePackages,
  fetchFromGitLab,
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
  gtk3,
  wrapGAppsHook3,
}:

buildDotnetModule rec {
  pname = "ryubing";
  version = "1.3.2";

  src = fetchFromGitLab {
    domain = "git.ryujinx.app";
    owner = "Ryubing";
    repo = "Ryujinx";
    tag = version;
    hash = "sha256-6BCDFd0nU96OgI5lqf4fbyNkG4PS5P4raHVbvBAhB5A=";
  };

  nativeBuildInputs =
    lib.optional stdenv.hostPlatform.isLinux [
      wrapGAppsHook3
    ]
    ++ lib.optional stdenv.hostPlatform.isDarwin [
      cctools
      darwin.sigtool
    ];

  enableParallelBuilding = false;

  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.runtime_9_0;

  nugetDeps = ./deps.json;

  runtimeDeps = [
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
    gtk3

    # Headless executable
    libGL
    SDL2
  ]
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) [
    udev
    pulseaudio
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin [ moltenvk ];

  projectFile = "Ryujinx.sln";
  testProjectFile = "src/Ryujinx.Tests/Ryujinx.Tests.csproj";

  # Tests on Darwin currently fail because of Ryujinx.Tests.Unicorn
  doCheck = !stdenv.hostPlatform.isDarwin;

  dotnetFlags = [
    "/p:ExtraDefineConstants=DISABLE_UPDATER%2CFORCE_EXTERNAL_BASE_DIR"
  ];

  executables = [
    "Ryujinx"
  ];

  makeWrapperArgs = lib.optional stdenv.hostPlatform.isLinux [
    # Without this Ryujinx fails to start on wayland. See https://github.com/Ryujinx/Ryujinx/issues/2714
    "--set SDL_VIDEODRIVER x11"
  ];

  preInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    # workaround for https://github.com/Ryujinx/Ryujinx/issues/2349
    mkdir -p $out/lib/sndio-6
    ln -s ${sndio}/lib/libsndio.so $out/lib/sndio-6/libsndio.so.6
  '';

  preFixup = ''
    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      mkdir -p $out/share/{applications,icons/hicolor/scalable/apps,mime/packages}

      pushd ${src}/distribution/linux

      install -D ./Ryujinx.desktop  $out/share/applications/Ryujinx.desktop
      install -D ./Ryujinx.sh       $out/bin/Ryujinx.sh
      install -D ./mime/Ryujinx.xml $out/share/mime/packages/Ryujinx.xml
      install -D ../misc/Logo.svg   $out/share/icons/hicolor/scalable/apps/Ryujinx.svg

      popd
    ''}

    # Don't make a softlink on OSX because of its case insensitivity
    ${lib.optionalString (!stdenv.hostPlatform.isDarwin) "ln -s $out/bin/Ryujinx $out/bin/ryujinx"}
  '';

  passthru.updateScript = ./updater.sh;

  meta = with lib; {
    homepage = "https://ryujinx.app";
    changelog = "https://git.ryujinx.app/ryubing/ryujinx/-/wikis/changelog";
    description = "Experimental Nintendo Switch Emulator written in C# (community fork of Ryujinx)";
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
      willow
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "Ryujinx";
  };
}

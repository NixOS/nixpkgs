{
  lib,
  buildDotnetModule,
  cctools,
  darwin,
  dotnetCorePackages,
  fetchFromForgejo,
  libx11,
  moltenvk,
  ffmpeg_6,
  openal,
  libsoundio,
  stdenv,
  vulkan-loader,
  libGL,
  libice,
  libsm,
  libxcursor,
  libxext,
  libxi,
  libxrandr,
  udev,
  SDL2,
  gtk3,
  wrapGAppsHook3,
}:
let
  pname = "ryubing";
  version = "1.3.3";
in
buildDotnetModule {
  inherit pname version;

  src = fetchFromForgejo {
    domain = "git.ryujinx.app";
    owner = "projects";
    repo = "Ryubing";
    tag = version;
    hash = "sha256-LhQaXxmj5HIgfmrsDN8GhhVXlXHpDO2Q8JtNLaCq0mk=";
  };

  patches = [
    # Includes a few packages which only vendor deps
    ./remove-dependency-nuget-pkgs.patch
    # libsoundio is handled differently, and may be removed in the future
    ./remove-vendored-libsoundio.patch
    # Vendored glfw is unused
    ./remove-unused-glfw.patch
  ];

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      wrapGAppsHook3
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      cctools
      darwin.sigtool
    ];

  enableParallelBuilding = false;

  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.runtime_9_0;

  nugetDeps = ./deps.json;

  runtimeDeps = [
    libx11
    openal
    vulkan-loader
    libGL

    # Avalonia UI
    libice
    libsm
    libxcursor
    libxext
    libxi
    libxrandr
    gtk3

    # Devendoring
    SDL2
    ffmpeg_6
    libsoundio
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ udev ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ moltenvk ];

  projectFile = "src/Ryujinx/Ryujinx.csproj";
  testProjectFile = "src/Ryujinx.Tests/Ryujinx.Tests.csproj";

  # Tests on Darwin currently fail because of Ryujinx.Tests.Unicorn
  doCheck = !stdenv.hostPlatform.isDarwin;

  dotnetFlags = [
    "/p:ExtraDefineConstants=DISABLE_UPDATER"
  ];

  executables = [
    "Ryujinx"
  ];

  makeWrapperArgs = lib.optional stdenv.hostPlatform.isLinux [
    # Without this Ryujinx fails to start on wayland. See https://github.com/Ryujinx/Ryujinx/issues/2714
    "--set"
    "SDL_VIDEODRIVER"
    "x11"
    # From upstream wrapper script
    "--set"
    "DOTNET_EnableAlternateStackCheck"
    "1"
  ];

  # Remove vendored SDL.
  preFixup = ''
    rm $out/lib/${pname}/libSDL2.*
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    install -D distribution/linux/Ryujinx.desktop $out/share/applications/Ryujinx.desktop
    install -D distribution/linux/mime/Ryujinx.xml $out/share/mime/packages/Ryujinx.xml
    install -D distribution/misc/Logo.svg $out/share/icons/hicolor/scalable/apps/Ryujinx.svg

    # Don't make a softlink on OSX because of its case insensitivity
    ln -s $out/bin/Ryujinx $out/bin/ryujinx
  '';

  passthru.updateScript = ./updater.sh;

  meta = {
    homepage = "https://ryujinx.app";
    # historical changelog https://git.ryujinx.app/projects/Ryubing/wiki/Changelog
    changelog = "https://git.ryujinx.app/projects/Ryubing/releases/tag/${version}";
    description = "Experimental Nintendo Switch Emulator written in C# (community fork of Ryujinx)";
    longDescription = ''
      Ryujinx is an open-source Nintendo Switch emulator, created by gdkchan,
      written in C#. This emulator aims at providing excellent accuracy and
      performance, a user-friendly interface and consistent builds. It was
      written from scratch and development on the project began in September
      2017. The project has since been abandoned on October 1st 2024 and QoL
      updates are now managed under a fork.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jk
      artemist
      willow
      ranidspace
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "Ryujinx";
  };
}

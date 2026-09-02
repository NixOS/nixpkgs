{
  lib,
  stdenv,
  config,
  nix-update-script,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  iconConvTools,
  copyDesktopItems,
  makeDesktopItem,
  libx11,
  libice,
  libsm,
  libxi,
  libxcursor,
  libxext,
  libxrandr,
  libGL,
  freetype,
  glib,
  alsa-lib,
  libjack2,
  pipewire,
  libpulseaudio,
  at-spi2-atk,
  at-spi2-core,
  libxkbcommon,
  wayland,
  fontconfig,
  dbus,
  alsaSupport ? stdenv.hostPlatform.isLinux,
  jackSupport ? stdenv.hostPlatform.isLinux,
  pipewireSupport ? stdenv.hostPlatform.isLinux,
  pulseaudioSupport ? config.pulseaudio or stdenv.hostPlatform.isLinux,
  soundfont-fluid,

  # Path to set ROBUST_SOUNDFONT_OVERRIDE to, essentially the default soundfont used.
  soundfont-path ? "${soundfont-fluid}/share/soundfonts/FluidR3_GM2-2.sf2",
}:
let
  version = "0.39.1";
  buildType = "Release";
in
buildDotnetModule {
  inherit version buildType;

  pname = "SS14.Launcher";

  src = fetchFromGitHub {
    owner = "space-wizards";
    repo = "SS14.Launcher";
    tag = "v${version}";
    hash = "sha256-u3tsPWAFMckWSHhiPqL50i9BMxR+VrLnpUSWGRRu9AA=";
    fetchSubmodules = true;
  };

  _structuredAttrs = true;
  strictDeps = true;

  nugetDeps = ./deps.json;

  passthru.updateScript = nix-update-script { };

  projectFile = [
    "SS14.Loader/SS14.Loader.csproj"
    "SS14.Launcher/SS14.Launcher.csproj"
  ];

  dotnet-sdk = dotnetCorePackages.sdk_10_0;

  executables = [ "SS14.Launcher" ];

  dotnetFlags = [
    "-p:FullRelease=true"
    "-p:RobustILLink=true"
    "-nologo"
  ];

  # Workaround to prevent buildDotnetModule from overriding assembly versions.
  # If this is not done it will break Robust.LoaderApi when connecting to a server!
  # I do not believe there is any way in nix (apart from overrideAttrs) to do this
  preBuild = ''
    version=""
    versionForDotnet=""
  '';

  runtimeDeps = [
    libGL
    freetype
    glib
    libx11
    libice
    libsm
    libxi
    libxcursor
    libxext
    libxrandr
    at-spi2-atk
    at-spi2-core
    libxkbcommon
    wayland
    fontconfig.lib
    dbus
  ]
  ++ lib.optional alsaSupport alsa-lib
  ++ lib.optional jackSupport libjack2
  ++ lib.optional pipewireSupport pipewire
  ++ lib.optional pulseaudioSupport libpulseaudio;

  # ${soundfont-path} is escaped here:
  # https://github.com/NixOS/nixpkgs/blob/d29975d32b1dc7fe91d5cb275d20f8f8aba399ad/pkgs/build-support/setup-hooks/make-wrapper.sh#L126C35-L126C45
  # via https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html under ${parameter@operator}
  makeWrapperArgs = [ "--set ROBUST_SOUNDFONT_OVERRIDE ${soundfont-path}" ];

  nativeBuildInputs = [
    iconConvTools
    copyDesktopItems
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "SS14.Launcher";
      exec = "SS14.Launcher";
      icon = "SS14";
      desktopName = "Space Station 14 Launcher";
      comment = "A multiplayer disaster simulator";
      categories = [ "Game" ];
      startupWMClass = "SS14.Launcher";
    })
  ];

  postInstall = ''
    mkdir -p $out/lib/SS14.Launcher/loader
    cp -r SS14.Loader/bin/${buildType}/*/*/* $out/lib/SS14.Launcher/loader/

    icoFileToHiColorTheme SS14.Launcher/Assets/icon.ico SS14 $out
  '';

  meta = {
    description = "Launcher for Space Station 14, a multiplayer game about paranoia and disaster";
    homepage = "https://spacestation14.com";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.coca ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "SS14.Launcher";
  };
}

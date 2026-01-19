{
  lib,
  stdenv,
  config,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  iconConvTools,
  copyDesktopItems,
  makeDesktopItem,
  libX11,
  libICE,
  libSM,
  libXi,
  libXcursor,
  libXext,
  libXrandr,
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
  alsaSupport ? stdenv.hostPlatform.isLinux,
  jackSupport ? stdenv.hostPlatform.isLinux,
  pipewireSupport ? stdenv.hostPlatform.isLinux,
  pulseaudioSupport ? config.pulseaudio or stdenv.hostPlatform.isLinux,
  soundfont-fluid,

  # Path to set ROBUST_SOUNDFONT_OVERRIDE to, essentially the default soundfont used.
  soundfont-path ? "${soundfont-fluid}/share/soundfonts/FluidR3_GM2-2.sf2",
}:
let
  version = "0.37.0";
  pname = "space-station-14-launcher";
in
buildDotnetModule rec {
  inherit pname;

  # Workaround to prevent buildDotnetModule from overriding assembly versions.
  name = "${pname}-${version}";

  # A bit redundant but I don't trust this package to be maintained by anyone else.
  src = fetchFromGitHub {
    owner = "space-wizards";
    repo = "SS14.Launcher";
    tag = "v${version}";
    hash = "sha256-s8HgD9nWh33rEamtsPj78XCLewmvhnsaI8BEtHWIlpE=";
    fetchSubmodules = true;
  };

  buildType = "Release";
  selfContainedBuild = false;

  projectFile = [
    "SS14.Loader/SS14.Loader.csproj"
    "SS14.Launcher/SS14.Launcher.csproj"
  ];

  nugetDeps = ./deps.json;

  passthru = {
    inherit version;
  };

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;

  dotnetFlags = [
    "-p:FullRelease=true"
    "-p:RobustILLink=true"
    "-nologo"
  ];

  nativeBuildInputs = [
    iconConvTools
    copyDesktopItems
  ];

  runtimeDeps = [
    libGL
    freetype
    glib
    libX11
    libICE
    libSM
    libXi
    libXcursor
    libXext
    libXrandr
    at-spi2-atk
    at-spi2-core
    libxkbcommon
    wayland
    fontconfig.lib
  ]
  ++ lib.optional alsaSupport alsa-lib
  ++ lib.optional jackSupport libjack2
  ++ lib.optional pipewireSupport pipewire
  ++ lib.optional pulseaudioSupport libpulseaudio;

  # ${soundfont-path} is escaped here:
  # https://github.com/NixOS/nixpkgs/blob/d29975d32b1dc7fe91d5cb275d20f8f8aba399ad/pkgs/build-support/setup-hooks/make-wrapper.sh#L126C35-L126C45
  # via https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html under ${parameter@operator}
  makeWrapperArgs = [ ''--set ROBUST_SOUNDFONT_OVERRIDE ${soundfont-path}'' ];

  executables = [ "SS14.Launcher" ];

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = meta.mainProgram;
      icon = pname;
      desktopName = "Space Station 14 Launcher";
      comment = meta.description;
      categories = [ "Game" ];
      startupWMClass = meta.mainProgram;
    })
  ];

  postInstall = ''
    mkdir -p $out/lib/space-station-14-launcher/loader
    cp -r SS14.Loader/bin/${buildType}/*/*/* $out/lib/space-station-14-launcher/loader/

    icoFileToHiColorTheme SS14.Launcher/Assets/icon.ico space-station-14-launcher $out
  '';

  meta = {
    description = "Launcher for Space Station 14, a multiplayer game about paranoia and disaster";
    homepage = "https://spacestation14.io";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "SS14.Launcher";
  };
}

{
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  flac,
  lib,
  libbfd,
  libGL,
  libpng,
  libpulseaudio,
  lz4,
  meson,
  minizip,
  ninja,
  nix-update-script,
  pkg-config,
  sdl3,
  sdl3-image,
  tracy,
  onetbb,
}:

stdenv.mkDerivation rec {
  pname = "cortex-command-community-project";
  version = "6.2.2-unstable-2025-11-30";

  src = fetchFromGitHub {
    owner = "cortex-command-community";
    repo = "Cortex-Command-Community-Project";
    rev = "2906eb86ddf1a41f4526fb0a4142bcd2c7c37b75";
    hash = "sha256-uPQRYXotcbqyneqQdppI9oJBmM61KMfHoapQJG7dta0=";
  };

  # src = ./Cortex-Command-Community-Project;

  patches = [
    ./nix-build.patch
  ];

  postFixup = ''
    patchelf --set-rpath ${lib.makeLibraryPath [ libpulseaudio ]} $out/lib/CortexCommand/libfmod.so*
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    sdl3
    flac
    libbfd
    libpng
    libpulseaudio
    libGL
    lz4
    minizip
    sdl3-image
    onetbb
    tracy
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cortex Command Community Project";
    longDescription = ''
      The Cortex Command Community Project is Free/Libre and Open Source under GNU AGPL v3.
      This is a community-driven effort to continue the development of Cortex Command.
    '';
    homepage = "https://cortex-command-community.github.io/";
    changelog = "https://github.com/cortex-command-community/Cortex-Command-Community-Project/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [
      agpl3Only # Cortex Command Community Project
      unfreeRedistributable # fmod
    ];
    maintainers = with lib.maintainers; [ gileri ];
    mainProgram = "CortexCommand";
    platforms = [ "x86_64-linux" ];
  };
}

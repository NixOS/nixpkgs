{
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  flac,
  lib,
  libGL,
  libpng,
  libpulseaudio,
  lz4,
  luajit,
  meson,
  minizip,
  ninja,
  nix-update-script,
  pkg-config,
  SDL2,
  SDL2_image,
  tbb,
}:

stdenv.mkDerivation rec {
  pname = "cortex-command-community-project";
  version = "6.2.2";

  src = fetchFromGitHub {
    owner = "cortex-command-community";
    repo = "Cortex-Command-Community-Project";
    tag = "v${version}";
    hash = "sha256-srbV6Nh+ecyV0dkY835vhzpMSzmnvANym453L72cmGI=";
  };

  patches = [
    (fetchpatch {
      name = "runner.patch";
      url = "https://github.com/cortex-command-community/Cortex-Command-Community-Project/commit/0aa22156567d48cb12ac39e31aec8aeb0ea7fb83.patch";
      hash = "sha256-2rpJtKjRebjVOjj3wlNfFBQjbn9UdEcIBWCkyZgzd+8=";
    })
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
    SDL2
    flac
    libpng
    libpulseaudio
    libGL
    lz4
    luajit
    minizip
    SDL2_image
    tbb
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

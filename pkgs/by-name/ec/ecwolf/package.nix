{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  makeWrapper,
  zlib,
  bzip2,
  libjpeg,
  SDL2,
  SDL2_net,
  SDL2_mixer,
  gtk3,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ecwolf";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "ECWolfEngine";
    repo = "ECWolf";
    tag = finalAttrs.version;
    hash = "sha256-T5K6B2fWMKMLB/662p/YLEv0Od9n0vUakznyoOnr0kI=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ makeWrapper ];
  buildInputs = [
    zlib
    bzip2
    libjpeg
    SDL2
    SDL2_net
    SDL2_mixer
    gtk3
  ];

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_LDFLAGS = toString [
      "-framework"
      "AppKit"
    ];
  };

  # ECWolf installs its binary to the games/ directory, but Nix only adds bin/
  # directories to the PATH.
  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/{Applications,bin}
    cp -R ecwolf.app $out/Applications
    makeWrapper $out/{Applications/ecwolf.app/Contents/MacOS,bin}/ecwolf
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Advanced source port for Wolfenstein 3D, Spear of Destiny, and Super 3D Noah's Ark";
    mainProgram = "ecwolf";
    homepage = "https://maniacsvault.net/ecwolf/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      jayman2000
      keenanweaver
    ];
    platforms = lib.platforms.all;
  };
})

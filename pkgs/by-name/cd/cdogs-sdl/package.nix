{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  SDL2,
  SDL2_image,
  SDL2_mixer,
  cmake,
  gtk3-x11,
  python3,
  protobuf,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cdogs-sdl";
  version = "2.3.2";

  src = fetchFromGitHub {
    repo = "cdogs-sdl";
    owner = "cxong";
    rev = finalAttrs.version;
    sha256 = "sha256-g1eLFdHsmqnz6zTlmaiLOXgX5dnS94k/PvaFJE3gfLo=";
  };

  postPatch = ''
    patchShebangs src/proto/nanopb/generator/*
  '';

  cmakeFlags = [
    "-DCDOGS_DATA_DIR=${placeholder "out"}/"
    "-DCMAKE_C_FLAGS=-Wno-error=array-bounds"
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    # Needed with GCC 12
    "-Wno-error=stringop-overflow"
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    (python3.withPackages (
      pp: with pp; [
        pp.protobuf
        setuptools
      ]
    ))
  ];

  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer
    gtk3-x11
    protobuf
  ];

  # inlining failed in call to 'tinydir_open': --param max-inline-insns-single limit reached
  hardeningDisable = [ "fortify3" ];

  meta = {
    homepage = "https://cxong.github.io/cdogs-sdl";
    description = "Open source classic overhead run-and-gun game";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ nixinator ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/cdogs-sdl.x86_64-darwin
  };
})

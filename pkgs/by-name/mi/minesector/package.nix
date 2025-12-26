{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  libtiff,
  libwebp,
  SDL2,
  SDL2_image,
  SDL2_ttf,
  SDL2_mixer,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "minesector";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "grassdne";
    repo = "minesector";
    tag = finalAttrs.version;
    hash = "sha256-VMTXZ4CIk9RpE4R9shHPl0R/T7mJUKY2b8Zi0DPW0/Q=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    libtiff
    libwebp
    SDL2
    SDL2_image
    SDL2_ttf
    SDL2_mixer
  ];

  strictDeps = true;

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "set(STATIC_LINK" "# set(STATIC_LINK"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "minesector";
    description = "Snazzy Minesweeper-based game built with SDL2";
    homepage = "https://github.com/grassdne/minesector";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})

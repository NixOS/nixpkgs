{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  ninja,
  SDL2,
  SDL2_mixer,
  simpleini,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "li-ri";
  version = "3.1.6";

  src = fetchFromGitHub {
    owner = "petitlapin";
    repo = "Li-Ri";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Dw4r0tRUBNQfJzKZI9R51ansRyg9rztBOXjcvjSgJic=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];
  buildInputs = [
    SDL2
    SDL2_mixer
    simpleini
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_SYSTEM_SIMPLEINI" true)
    (lib.cmakeFeature "LIRI_DATA_DIR" "${placeholder "out"}/share/Li-ri/")
  ];

  meta = {
    homepage = "https://github.com/petitlapin/Li-Ri";
    description = "Drive a toy wood engine and collect all the coaches to win";
    maintainers = with lib.maintainers; [
      jcumming
      marcin-serwin
    ];
    platforms = with lib.platforms; linux;
    license = with lib.licenses; [
      # Code
      gpl2Only
      # or
      gpl3Only

      # Metadata
      cc0
    ];
    mainProgram = "Li-ri";
  };
})

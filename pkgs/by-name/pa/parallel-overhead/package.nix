{
  lib,
  stdenv,
  fetchFromCodeberg,
  SDL2,
  libGL,
  fetchpatch,
  help2man,
  sfxr-qt,
  lmms,
  desktop-file-utils,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "parallel-overhead";
  version = "1.1.4";

  src = fetchFromCodeberg {
    owner = "Huitsi";
    repo = "ParallelOverhead";
    tag = finalAttrs.version;
    hash = "sha256-jWjFT0Je+G/WtXIwOrDDt2/fBjRe4LC+DDODypfBq50=";
  };

  patches = [
    (fetchpatch {
      name = "fix-gcc15.patch";
      url = "https://codeberg.org/Huitsi/ParallelOverhead/commit/1379f48d793807278eb954e93218021a9cdf8099.patch";
      hash = "sha256-mdHZsPBGPY3BwVsM/oUr6j3ccolLbeFvj2u8TxUGSFU=";
    })
    (fetchpatch {
      name = "fix-hardening-error.patch";
      url = "https://codeberg.org/Huitsi/ParallelOverhead/commit/dc5cf737235757e7bf90ed5dab37473b71655b13.patch";
      hash = "sha256-yAicPkLXkt8jTbw7Hd6V2l4oIKScUFe4XLYhOlocuSU=";
    })
  ];

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    help2man
    sfxr-qt
    lmms
    desktop-file-utils
  ];

  buildInputs = [
    SDL2
    libGL
  ];

  makeFlags = [
    "version=${finalAttrs.version}"
    "prefix=${placeholder "out"}"
    "bindir=$(exec_prefix)/bin"
  ];

  meta = {
    description = "Endless runner game";
    homepage = "https://huitsi.net/#ParallelOverhead";
    license = with lib.licenses; [
      mit

      # Music
      cc0
    ];
    maintainers = with lib.maintainers; [ marcin-serwin ];
    mainProgram = "parallel_overhead";
    platforms = lib.platforms.linux;
  };
})

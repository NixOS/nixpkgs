{
  lib,
  stdenv,
  bzip2,
  cmake,
  fetchFromGitHub,
  fetchpatch,
  ncurses,
  python3,
  readline,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spades";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "ablab";
    repo = "spades";
    rev = "v${finalAttrs.version}";
    hash = "sha256-k2+ddJIgGE41KGZODovU9VdurbWerEtdqNrFDwyuFjo=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  patches = [
    # https://github.com/ablab/spades/pull/1314
    (fetchpatch {
      name = "copytree.patch";
      url = "https://github.com/ablab/spades/commit/af1f756a46c5da669897b841d4f753af1eaa9588.patch";
      hash = "sha256-tkT7hb0TqsbLkcTs9u43nzvV8bVdh3G9VKYqFFLrQv8=";
      stripLen = 3;
      extraPrefix = "projects/";
    })
  ];

  cmakeFlags = [
    "-DZLIB_ENABLE_TESTS=OFF"
    "-DSPADES_BUILD_INTERNAL=OFF"
  ];

  preConfigure = ''
    # The CMakeListsInternal.txt file should be empty in the release tarball
    echo "" > CMakeListsInternal.txt
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    bzip2
    ncurses
    python3
    readline
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-faligned-allocation";

  doCheck = true;

  strictDeps = true;

  meta = {
    description = "St. Petersburg genome assembler, a toolkit for assembling and analyzing sequencing data";
    changelog = "https://github.com/ablab/spades/blob/${finalAttrs.version}/changelog.md";
    downloadPage = "https://github.com/ablab/spades";
    homepage = "http://ablab.github.io/spades";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ bzizou ];
    broken = stdenv.hostPlatform.isMusl;
  };
})

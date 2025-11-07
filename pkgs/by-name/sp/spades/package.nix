{
  lib,
  stdenv,
  bzip2,
  cmake,
  fetchFromGitHub,
  ncurses,
  python3,
  readline,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spades";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "ablab";
    repo = "spades";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BlZjfZKtCm1kWNPjdth3pYFN0plU7xfTsFotPefzzMY=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

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

{
  lib,
  stdenv,
  bzip2,
  cmake,
  fetchFromGitHub,
  fetchpatch2,
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

  patches = [
    # Add missing <cstdint> for uint{8,64}_t to fix build with gcc 15.
    (fetchpatch2 {
      url = "https://github.com/ablab/spades/commit/10b6af96ead72fdb19e8e524aa24bdcff9986e76.patch?full_index=1";
      relative = "src";
      hash = "sha256-yAQVqE6DwPe+GZ4VR1cGytaO8NmHz6TUG7EdtbxIuTU=";
    })
  ];

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

{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  makeWrapper,
  flex,
  bison,
  perlPackages,
  libminc,
  libjpeg,
  nifticlib,
  zlib,
}:

let
  inherit (perlPackages) perl TextFormat;
in

stdenv.mkDerivation {
  pname = "minc-tools";
  version = "2.3.06-unstable-2024-11-28";

  src = fetchFromGitHub {
    owner = "BIC-MNI";
    repo = "minc-tools";
    rev = "a72077d92266f9ea4c49b6dd3efd5766b81a104c";
    hash = "sha256-YafO5UjeADO/658Xm973JtqldRYkGQ4v8m1oNJoZrbM=";
  };

  # Fix for CMake > 4 in which the old policy for CMP0026 was removed.
  # Note this breaks the tests, but they are not enabled anyway.
  # Upstream issue: https://github.com/BIC-MNI/minc-tools/issues/123
  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail "SET CMP0026 OLD" "SET CMP0026 NEW"

    # FIX: Rename the colliding NAN token to MINC_NAN in the flex/bison parser files
    sed -i 's/\bNAN\b/MINC_NAN/g' progs/minccalc/gram.y progs/minccalc/lex.l

    # FIX: Rename the colliding fdiv function to avoid glibc 2.42 <math.h> conflicts
    sed -i 's/\bfdiv\b/minc_fdiv/g' progs/mincblob/mincblob.c

    # FIX: Remove legacy unprototyped C declarations that break under GCC 15 strictness
    sed -i 's/, \*mat_create()//g' conversion/minctoecat/ecat_write.c
    sed -i 's/\*fopen(), //g' conversion/minctoecat/ecat_write.c
  '';

  nativeBuildInputs = [
    cmake
    flex
    bison
    makeWrapper
  ];

  buildInputs = [
    libminc
    libjpeg
    nifticlib
    zlib
  ];

  propagatedBuildInputs = [
    perl
    TextFormat
  ];

  cmakeFlags = [
    "-DLIBMINC_DIR=${libminc}/lib/cmake"
    "-DZNZ_INCLUDE_DIR=${nifticlib}/include/nifti"
    "-DNIFTI_INCLUDE_DIR=${nifticlib}/include/nifti"
  ];

  env.NIX_CFLAGS_COMPILE = "-D_FillValue=NC_FillValue";

  postFixup = ''
    for prog in minccomplete minchistory mincpik; do
      wrapProgram $out/bin/$prog --prefix PERL5LIB : $PERL5LIB
    done
  '';

  meta = {
    homepage = "https://github.com/BIC-MNI/minc-tools";
    description = "Command-line utilities for working with MINC files";
    maintainers = with lib.maintainers; [ bcdarwin ];
    platforms = lib.platforms.unix;
    license = lib.licenses.free;
    broken = stdenv.hostPlatform.isDarwin;
  };
}

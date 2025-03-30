{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  makeWrapper,
  perlPackages,
  libminc,
}:

stdenv.mkDerivation {
  pname = "mni_autoreg";
  version = "0.99.70-unstable-2024-10-04";

  src = fetchFromGitHub {
    owner = "BIC-MNI";
    repo = "mni_autoreg";
    rev = "85265398d90dc1bfef886e2cf876a1a2caae86b4";
    hash = "sha256-tKCDrIHlkArF5Xv6NlSkvmNMIMDsxEf5O3ATzm6DabQ=";
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];
  buildInputs = [ libminc ];
  propagatedBuildInputs = with perlPackages; [
    perl
    GetoptTabular
    MNI-Perllib
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=implicit-function-declaration"
    "-Wno-error=incompatible-pointer-types"
  ];

  cmakeFlags = [
    "-DLIBMINC_DIR=${libminc}/lib/cmake"
    (lib.cmakeFeature "PERL_EXECUTABLE" (lib.getExe perlPackages.perl))
  ];
  # testing broken: './minc_wrapper: Permission denied' from Testing/ellipse0.mnc

  postFixup = ''
    for prog in autocrop mritoself mritotal xfmtool; do
      echo $out/bin/$prog
      wrapProgram $out/bin/$prog --prefix PERL5LIB : $PERL5LIB;
    done
  '';

  meta = {
    homepage = "https://github.com/BIC-MNI/mni_autoreg";
    description = "Tools for automated registration using the MINC image format";
    maintainers = with lib.maintainers; [ bcdarwin ];
    platforms = lib.platforms.unix;
    license = lib.licenses.free;
  };
}

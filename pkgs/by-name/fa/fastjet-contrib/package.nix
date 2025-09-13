{
  lib,
  stdenv,
  fetchurl,
  fastjet,
}:

stdenv.mkDerivation rec {
  pname = "fastjet-contrib";
  version = "1.101";

  src = fetchurl {
    url = "https://fastjet.hepforge.org/contrib/downloads/fjcontrib-${version}.tar.gz";
    sha256 = "sha256-2+itIZn3LWTdKfYhj29T793I+z5d2cXRDy/R4j1uRPY=";
  };

  buildInputs = [ fastjet ];

  postPatch = ''
    for f in Makefile.in */Makefile scripts/internal/Template/Makefile; do
      substituteInPlace "$f" --replace "CXX=g++" ""
      substituteInPlace "$f" --replace-quiet "ar " "${stdenv.cc.targetPrefix}ar "
      substituteInPlace "$f" --replace-quiet "ranlib " "${stdenv.cc.targetPrefix}ranlib "
    done
    patchShebangs --build ./utils/check.sh ./utils/install-sh
    substituteInPlace configure \
      --replace-warn "-Wl,-soname,fastjetcontribfragile.so.0" "-Wl,-soname,libfastjetcontribfragile.so"
  '';

  # Written in shell manually, does not support autoconf-style
  # --build=/--host= options:
  #   Error: --build=x86_64-unknown-linux-gnu: unrecognised argument
  configurePlatforms = [ ];

  configureFlags = [
    "--fastjet-config=${lib.getExe' (lib.getDev fastjet) "fastjet-config"}"
  ];

  enableParallelBuilding = true;

  doCheck = true;

  postBuild = ''
    make fragile-shared
  '';

  postInstall = ''
    make fragile-shared-install
  '';

  meta = {
    description = "Third party extensions for FastJet";
    homepage = "http://fastjet.fr/";
    changelog = "https://phab.hepforge.org/source/fastjetsvn/browse/contrib/tags/${version}/NEWS?as=source&blame=off";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ veprbl ];
    platforms = lib.platforms.unix;
  };
}

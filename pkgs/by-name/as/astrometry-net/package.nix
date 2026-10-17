{ lib, stdenv, fetchFromGitHub, python3, cairo, netpbm, libpng, libjpeg, zlib, bzip2, swig, cfitsio, pkg-config, gsl }:

stdenv.mkDerivation (FinalAttr: {
  pname = "astrometry.net";
  version = "0.94";
  version_date = "2023-05-01";

  src = fetchFromGitHub {
    owner = "dstndstn";
    repo = FinalAttr.pname;
    rev = FinalAttr.version;
    hash = "sha256-/g9cqgcoxYQAmSdNrdAN/ZkQBu2xynOFYzfZnhKgKF8=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ python3 cairo netpbm libpng libjpeg zlib bzip2 swig cfitsio gsl ];
  propagatedBuildInputs = with python3.pkgs; [ numpy ];

  preConfigure = ''
    patchShebangs .
  '';

  makeFlags = [ "INSTALL_DIR=$(out)" "AN_GIT_REVISION=${FinalAttr.version}" "AN_GIT_DATE=${FinalAttr.version_date}" ];

  meta = with lib; {
    description = "Automatic recognition of astronomical images";
    homepage = "https://astrometry.net/";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.bzizou ];
    platforms = platforms.unix;
  };
})

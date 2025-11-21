{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  curl,
  libxml2,
  pam,
  sblim-sfcc,
}:

stdenv.mkDerivation rec {
  pname = "openwsman";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "Openwsman";
    repo = "openwsman";
    tag = "v${version}";
    hash = "sha256-jXsnjnYZ2UiEj3sJDhMuWlopIECKLraqgIV4evw5Tbw=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    curl
    libxml2
    pam
    sblim-sfcc
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_RUBY_GEM=no"
    "-DBUILD_PYTHON=no"
    "-DBUILD_PYTHON3=yes"
  ];

  preConfigure = ''
    appendToVar cmakeFlags "-DPACKAGE_ARCHITECTURE=$(uname -m)"
  '';

  configureFlags = [ "--disable-more-warnings" ];

  meta = {
    description = "Open source implementation of WS-Management";
    downloadPage = "https://github.com/Openwsman/openwsman/releases";
    homepage = "https://openwsman.github.io";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ deepfire ];
    platforms = lib.platforms.linux; # PAM is not available on Darwin
  };
}

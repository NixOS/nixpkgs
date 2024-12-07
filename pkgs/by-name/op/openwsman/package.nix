{ lib, stdenv, fetchFromGitHub, cmake, pkg-config
, curl, libxml2, pam, sblim-sfcc }:

stdenv.mkDerivation rec {
  pname = "openwsman";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner  = "Openwsman";
    repo   = "openwsman";
    rev    = "v${version}";
    sha256 = "sha256-P4N0GRQpaxsWku/KCd/U2tzo2vJJk7iIWg4Cf8XzW10=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ curl libxml2 pam sblim-sfcc ];

  cmakeFlags = [
    "-DCMAKE_BUILD_RUBY_GEM=no"
    "-DBUILD_PYTHON=no"
    "-DBUILD_PYTHON3=yes"
  ];

  preConfigure = ''
    appendToVar cmakeFlags "-DPACKAGE_ARCHITECTURE=$(uname -m)"
  '';

  configureFlags = [ "--disable-more-warnings" ];

  meta = with lib; {
    description  = "Openwsman server implementation and client API with bindings";
    downloadPage = "https://github.com/Openwsman/openwsman/releases";
    homepage     = "https://openwsman.github.io";
    license      = licenses.bsd3;
    maintainers  = with maintainers; [ deepfire ];
    platforms    = platforms.linux; # PAM is not available on Darwin
  };
}

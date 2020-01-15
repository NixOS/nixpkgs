{ stdenv, lib, fetchFromGitHub, fetchpatch, fetchurl, cmake, xlibsWrapper
, ApplicationServices, Carbon, Cocoa, CoreServices, ScreenSaver, avahi
, libX11, libXi, libXtst, libXrandr, xinput, curl, openssl, unzip, qtbase }:

stdenv.mkDerivation rec {
  pname = "synergy";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "symless";
    repo = "synergy-core";
    rev = "${version}-stable";
    sha256 = "1jk60xw4h6s5crha89wk4y8rrf1f3bixgh5mzh3cq3xyrkba41gh";
  };

  cmakeFlags = lib.optionals stdenv.isDarwin [ "-DOSX_TARGET_MAJOR=10" "-DOSX_TARGET_MINOR=7" ];

  buildInputs = [
    cmake curl openssl qtbase
  ] ++ lib.optionals stdenv.isDarwin [
    ApplicationServices Carbon Cocoa CoreServices ScreenSaver
  ] ++ lib.optionals stdenv.isLinux [
    xlibsWrapper libX11 libXi libXtst libXrandr xinput avahi
  ];

  installPhase = ''
    mkdir -p $out
    cp -r bin $out
  '';

  meta = with lib; {
    description = "Share one mouse and keyboard between multiple computers";
    homepage = http://synergy-project.org/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ aszlig enzime ];
    platforms = platforms.all;
  };
}

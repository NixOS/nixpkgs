{ lib, stdenv, fetchFromGitLab , go-md2man, coreutils, substituteAll }:

stdenv.mkDerivation rec {
  pname = "brillo";
  version = "1.4.12";

  src = fetchFromGitLab {
    owner= "cameronnemo";
    repo= "brillo";
    rev= "v${version}";
    hash = "sha256-dKGNioWGVAFuB4kySO+QGTnstyAD0bt4/6FBVwuRxJo=";
  };

  patches = [
    (substituteAll {
      src = ./udev-rule.patch;
      inherit coreutils;
    })
  ];

  nativeBuildInputs = [ go-md2man ];

  makeFlags = [ "PREFIX=$(out)" "AADIR=$(out)/etc/apparmor.d" ];

  installTargets = [ "install-dist" ];

  meta = with lib; {
    description = "Backlight and Keyboard LED control tool";
    homepage = "https://gitlab.com/cameronnemo/brillo";
    mainProgram = "brillo";
    license = [ licenses.gpl3 licenses.bsd0 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.alexarice ];
  };
}

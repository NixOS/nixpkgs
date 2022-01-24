{ lib, stdenv, fetchFromGitHub, coreutils, nixosTests }:

stdenv.mkDerivation rec {
  pname = "3proxy";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "z3APA3A";
    repo = pname;
    rev = version;
    sha256 = "sha256-4bLlQ/ULvpjs6fr19yBBln5mRRc+yj+zVLiTs1e/Ypc=";
  };

  makeFlags = [
    "-f Makefile.Linux"
    "INSTALL=${coreutils}/bin/install"
    "DESTDIR=${placeholder "out"}"
  ];

  passthru.tests = {
    smoke-test = nixosTests._3proxy;
  };

  meta = with lib; {
    description = "Tiny free proxy server";
    homepage = "https://github.com/z3APA3A/3proxy";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ misuzu ];
  };
}

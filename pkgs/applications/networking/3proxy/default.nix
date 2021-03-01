{ lib, stdenv, fetchFromGitHub, coreutils }:

stdenv.mkDerivation rec {
  pname = "3proxy";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "z3APA3A";
    repo = pname;
    rev = version;
    sha256 = "9aopwyz0U2bYTvx5YWLJo9EE8Xfb51IOguHRJodjpm8=";
  };

  makeFlags = [
    "-f Makefile.Linux"
    "INSTALL=${coreutils}/bin/install"
    "DESTDIR=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "Tiny free proxy server";
    homepage = "https://github.com/z3APA3A/3proxy";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ misuzu ];
  };
}

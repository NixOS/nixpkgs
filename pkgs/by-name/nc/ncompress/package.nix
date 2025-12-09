{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "ncompress";
  version = "5.0";

  src = fetchFromGitHub {
    owner = "vapier";
    repo = "ncompress";
    rev = "v${version}";
    sha256 = "sha256-Yhs3C5/kR7Ve56E84usYJprxIMAIwXVahLi1N9TIfj0=";
  };

  makeFlags = [ "PREFIX=$(out)" ];
  installTargets = "install_core";

  postInstall = ''
    mv $out/bin/uncompress $out/bin/uncompress-ncompress
  '';

  meta = with lib; {
    homepage = "http://ncompress.sourceforge.net/";
    license = licenses.publicDomain;
    description = "Fast, simple LZW file compressor";
    platforms = platforms.unix;
  };
}

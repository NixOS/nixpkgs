{ lib, stdenv, fetchgit, unzip, pkg-config, ncurses, libX11, libXft, cwebbin }:

stdenv.mkDerivation {
  pname = "edit-nightly";
  version = "20180228";

  src = fetchgit {
    url = "git://c9x.me/ed.git";
    rev = "77d96145b163d79186c722a7ffccfff57601157c";
    sha256 = "0rsmp7ydmrq3xx5q19566is9a2v2w5yfsphivfc7j4ljp32jlyyy";
  };

  nativeBuildInputs = [
    unzip
    pkg-config
    cwebbin
  ];

  buildInputs = [
    ncurses
    libX11
    libXft
  ];

  preBuild = ''
    ctangle *.w
  '';

  installPhase = ''
    install -Dm755 obj/edit -t $out/bin
  '';

  meta = with lib; {
    description = "A relaxing mix of Vi and ACME";
    homepage = "https://c9x.me/edit";
    license = licenses.publicDomain;
    maintainers = [ maintainers.vrthra ];
    platforms = platforms.all;
  };
}

{ fetchurl, stdenv, fetchgit, qt4, pkgconfig, boost, dbus }:

stdenv.mkDerivation rec {
  rev = "9f52882688ba03d7aaab2e3fd83cb05cfbf1a374";
  name = "twmn-${rev}";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/sboli/twmn.git";
    sha256 = "1jd2y0ydcpjdmjbx77lw35710sqfwbgyrnpv66mi3gwvrbyiwpf3";
  };

  buildInputs = [ qt4 pkgconfig boost ];
  propagatedBuildInputs = [ dbus ];

  configurePhase = "qmake";

  installPhase = ''
    mkdir -p "$out/bin"
    cp bin/* "$out/bin"
  '';

  meta = {
    description = "A notification system for tiling window managers";
    homepage = "https://github.com/sboli/twmn";
    platforms = with stdenv.lib.platforms; linux;
    maintainers = [ stdenv.lib.maintainers.matejc ];
  };
}

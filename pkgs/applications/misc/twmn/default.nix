{ fetchurl, stdenv, fetchgit, qt5, pkgconfig, boost }:

stdenv.mkDerivation rec {
  name = "twmn-git-2014-09-23";

  src = fetchgit {
    url = "https://github.com/sboli/twmn.git";
    rev = "9492a47e25547e602dd57efd807033677c90b150";
    sha256 = "9c91e9d3d6d7f9d90d34da6f1a4b9f3dee65605c1e43729417d6921c54dded6b";
  };

  buildInputs = [ qt5.base qt5.x11extras pkgconfig boost ];

  configurePhase = ''
    sed -i s/-Werror// twmnd/twmnd.pro
    qmake
  '';

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

{ stdenv, fetchurl, qt4, qmake4Hook, libXext, libX11, sourceFromHead }:

stdenv.mkDerivation rec {
  name = "qgit-git";

  meta =
  {
    license = stdenv.lib.licenses.gpl2;
    homepage = "http://digilander.libero.it/mcostalba/";
    description = "Graphical front-end to Git";
  };

  # REGION AUTO UPDATE:    { name="qgit"; type="git"; url="git://git.kernel.org/pub/scm/qgit/qgit4.git"; }
  src = sourceFromHead "qgit-a0252ed2a6a72b50e65d027adce8afa22e874277.tar.gz"
               (fetchurl { url = "http://mawercer.de/~nix/repos/qgit-a0252ed2a6a72b50e65d027adce8afa22e874277.tar.gz"; sha256 = "17e4727ac68b4f2e8503289d5b6a2c042547e7be133e7f8195b79e33eab61b93"; });
  # END

  buildInputs = [ qt4 libXext libX11 ];

  nativeBuildInputs = [ qmake4Hook ];
}

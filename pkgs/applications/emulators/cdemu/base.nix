{ pname, version, pkgSha256 }:
attrs@{ lib, stdenv, fetchurl, cmake, pkg-config, buildInputs, drvParams ? {}, ... }:
stdenv.mkDerivation ( rec {
  inherit pname version buildInputs;
  src = fetchurl {
    url = "mirror://sourceforge/cdemu/${pname}-${version}.tar.xz";
    sha256 = pkgSha256;
  };
  nativeBuildInputs = (attrs.nativeBuildInputs or [ ]) ++ [ pkg-config cmake ];
  setSourceRoot = ''
    mkdir build
    cd build
    sourceRoot="`pwd`"
  '';
  configurePhase = ''
    cmake ../${pname}-${version} -DCMAKE_INSTALL_PREFIX=$out -DCMAKE_BUILD_TYPE=Release -DCMAKE_SKIP_RPATH=ON
  '';
  meta = with lib; {
    description = "A suite of tools for emulating optical drives and discs";
    longDescription = ''
      CDEmu consists of:

      - a kernel module implementing a virtual drive-controller
      - libmirage which is a software library for interpreting optical disc images
      - a daemon which emulates the functionality of an optical drive+disc
      - textmode and GTK clients for controlling the emulator
      - an image analyzer to view the structure of image files

      Optical media emulated by CDemu can be mounted within Linux. Automounting is also allowed.
    '';
    homepage = "https://cdemu.sourceforge.io/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with lib.maintainers; [ bendlas ];
  };
} // drvParams)

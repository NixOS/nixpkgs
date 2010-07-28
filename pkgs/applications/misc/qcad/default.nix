# translations still misssing

{ stdenv, fetchurl, qt3, libpng, libXext, libX11 }:

stdenv.mkDerivation {
  name = "qcad-2.0.5.0-1-community";

  src = fetchurl {
    url = http://www.ribbonsoft.com/archives/qcad/qcad-2.0.5.0-1-community.src.tar.gz;
    sha256 = "07aiw7zjf1fc04dhgwwp29adwb2qs165n7v04lh09zy0k2aplcl3";
  };

  # TODO: add translations
  buildPhase = ''
    cd scripts
    sh build_qcad.sh notrans
    cd ..
  '';

  buildInputs = [ qt3 libpng libXext libX11 ];

  patchPhase = ''
    sed -i 's/-pedantic//' mkspecs/defs.pro
    patch -p1 < ${ ./qcad-2.0.4.0-1.src-intptr.patch /* taken from gentoo, fixes amd64 compilation issue */}
  '';

  # probably there is more to be done. But this seems to work for now (eg see gentoo ebuild)
  installPhase = ''
    ensureDir $out/{bin,share}
    cp -r qcad $out/share
    cat >> $out/bin/qcad << EOF
    #!/bin/sh
    cd $out/share/qcad
    ./qcad "\$@"
    EOF
    chmod +x $out/bin/qcad
  '';

  meta = { 
    description = "A 2D CAD package based upon Qt";
    homepage = http://www.ribbonsoft.de/qcad.html;
    license = "GPLv2"; # community edition
  };
}

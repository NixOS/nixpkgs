{ stdenv, fetchgit, unzip, pkgconfig, ncurses, libX11, libXft, cwebbin }:

stdenv.mkDerivation rec {
  name = "edit-nightly-${version}";
  version = "20160425";

  src = fetchgit {
    url = git://c9x.me/ed.git;
    rev = "323d49b68c5e804ed3b8cada0e2274f1589b3484";
    sha256 = "0wv8i3ii7cd9bqhjpahwp2g5fcmyk365nc7ncmvl79cxbz3f7y8v";
  };

  buildInputs = [
     unzip
     pkgconfig
     ncurses
     libX11
     libXft
     cwebbin
  ];

  buildPhase = ''
    ctangle *.w
    make
  '';

  installPhase = ''
    mkdir -p $out/bin/
    cp obj/edit $out/bin/edit
  '';

  meta = with stdenv.lib; {
    description = "A relaxing mix of Vi and ACME";
    homepage = http://c9x.me/edit;
    license = licenses.publicDomain;
    maintainers = [ maintainers.vrthra ];
    platforms = platforms.linux;
  };
}


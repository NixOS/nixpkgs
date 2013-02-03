{ stdenv, fetchurl, freeglut, gtk2, gtkglext, libjpeg_turbo, libtheora, libXmu
, lua, mesa, pkgconfig, perl, automake, autoconf, libtool, gettext
}:

let
  name = "celestia-1.6.1";

  gcc46Patch = fetchurl {
    url = "https://projects.archlinux.org/svntogit/packages.git/plain/trunk/celestia-1.6.1-gcc46.patch?h=packages/celestia";
    sha256 = "1q840ip5h2q93r0d68jwrvf40ns5qzqss9vzd6xnwvs3wa77m5wp";
    name = "celestia-1.6.1-gcc46.patch";
  };

  libpng15Patch = fetchurl {
    url = "https://projects.archlinux.org/svntogit/packages.git/plain/trunk/celestia-1.6.1-libpng15.patch?h=packages/celestia";
    sha256 = "19yqbi5k944d3jm0q2mvcfg52kicy4j347gj62dyaijzj505x4pm";
    name = "celestia-1.6.1-libpng15.patch";
  };

  linkingPatch = fetchurl {
    url = "https://projects.archlinux.org/svntogit/packages.git/plain/trunk/celestia-1.6.1-linking.patch?h=packages/celestia";
    sha256 = "1qzv18b2prqbhy21js5bnf7vwkmrq1dmrq8r0wab7v10axjqdv35";
    name = "celestia-1.6.1-linking.patch";
  };

  gcc47Patch = fetchurl {
    url = "https://projects.archlinux.org/svntogit/packages.git/plain/trunk/gcc-4.7-fixes.diff?h=packages/celestia";
    sha256 = "1jqkafwrg1829cwqvlxxkqbf42zqfsgpqd8a5b2qlzma5napdmg5";
    name = "gcc-4.7-fixes.diff";
  };
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://sourceforge/celestia/${name}.tar.gz";
    sha256 = "1i1lvhbgllsh2z8i6jj4mvrjak4a7r69psvk7syw03s4p7670mfk";
  };

  buildInputs = [ freeglut gtk2 gtkglext libjpeg_turbo libtheora libXmu mesa pkgconfig lua
    perl automake autoconf libtool gettext  ];

  patchPhase = ''
    patch -Np0 -i "${gcc46Patch}"
    patch -Np0 -i "${libpng15Patch}"
    patch -Np1 -i "${linkingPatch}"
    patch -Np1 -i "${gcc47Patch}"
    autoreconf
    configureFlagsArray=( --with-gtk --with-lua=${lua} CFLAGS="-O2 -fsigned-char" CXXFLAGS="-O2 -fsigned-char" )
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Free space simulation";
    homepage = "http://www.shatters.net/celestia/";
    license = stdenv.lib.licenses.gpl2;

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}

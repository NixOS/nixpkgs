{ stdenv, fetchurl, freeglut, gtk2, gtkglext, libjpeg_turbo, libtheora, libXmu
, lua, mesa, pkgconfig, perl, autoreconfHook, glib, cairo
, pango, gdk_pixbuf, atk
}:

let
  name = "celestia-1.6.1";

  gcc46Patch = fetchurl {
    url = "https://projects.archlinux.org/svntogit/packages.git/plain/trunk/celestia-1.6.1-gcc46.patch?h=packages/celestia";
    sha256 = "0my7dpyh5wpz5df7bjhwb4db3ci2rn8ib1nkjv15fbp1g76bxfaz";
    name = "celestia-1.6.1-gcc46.patch";
  };

  libpng15Patch = fetchurl {
    url = "https://projects.archlinux.org/svntogit/packages.git/plain/trunk/celestia-1.6.1-libpng15.patch?h=packages/celestia";
    sha256 = "1jrmbwmvs9b6k2b2g4104q22v4vqi0wfpz6hmfhniaq34626jcms";
    name = "celestia-1.6.1-libpng15.patch";
  };

  libpng16Patch = fetchurl {
    url = "https://projects.archlinux.org/svntogit/packages.git/plain/trunk/celestia-1.6.1-libpng16.patch?h=packages/celestia";
    sha256 = "1q85prw4ci6d50lri8w1jm19pghxw96qizf5dl4g0j86rlhlkc8f";
    name = "celestia-1.6.1-libpng16.patch";
  };

  linkingPatch = fetchurl {
    url = "https://projects.archlinux.org/svntogit/packages.git/plain/trunk/celestia-1.6.1-linking.patch?h=packages/celestia";
    sha256 = "1m8xyq26nm352828bp12c3b8f6m9bys9fwfxbfzqppllk7il2f24";
    name = "celestia-1.6.1-linking.patch";
  };

  gcc47Patch = fetchurl {
    url = "https://projects.archlinux.org/svntogit/packages.git/plain/trunk/gcc-4.7-fixes.diff?h=packages/celestia";
    sha256 = "1na26c7pv9qfv8a981m1zvglhv05r3h8513xqjra91qhhzx8wr8n";
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
    perl autoreconfHook ];

  patchPhase = ''
    patch -Np0 -i "${gcc46Patch}"
    patch -Np0 -i "${libpng15Patch}"
    patch -Np2 -i "${libpng16Patch}"
    patch -Np1 -i "${linkingPatch}"
    patch -Np1 -i "${gcc47Patch}"
  '';

  configureFlags = "--with-gtk --with-lua=${lua}";
  CPPFLAGS = "-DNDEBUG";
  CFLAGS = "-O2 -fsigned-char";
  CXXFLAGS = "-O2 -fsigned-char";
  GTK_CFLAGS = "-I${gtk2.dev}/include/gtk-2.0 -I${gtk2.out}/lib/gtk-2.0/include -I${glib.dev}/include/glib-2.0 -I${glib.out}/lib/glib-2.0/include -I${cairo.dev}/include/cairo -I${pango.dev}/include/pango-1.0 -I${gdk_pixbuf.dev}/include/gdk-pixbuf-2.0 -I${atk}/include/atk-1.0 -I${gtkglext}/include/gtkglext-1.0 -I${gtkglext}/lib/gtkglext-1.0/include";
  GTK_LIBS = "-lgtk-x11-2.0 -lgtkglext-x11-1.0 -lcairo -lgdk_pixbuf-2.0 -lpango-1.0 -lgobject-2.0";

  installPhase = ''make MKDIR_P="mkdir -p" install'';

  enableParallelBuilding = true;

  meta = {
    description = "Free space simulation";
    homepage = "http://www.shatters.net/celestia/";
    license = stdenv.lib.licenses.gpl2;

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}

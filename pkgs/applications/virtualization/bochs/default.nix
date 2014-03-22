{ stdenv, fetchurl
, libX11 , mesa
, sdlSupport ? true, SDL ? null
, termSupport ? true , ncurses ? null, readline ? null
, wxSupport ? true , gtk ? null , wxGTK ? null , pkgconfig ? null
, wgetSupport ? false, wget ? null
, curlSupport ? false, curl ? null
}:


assert sdlSupport -> (SDL != null);
assert termSupport -> (ncurses != null&& readline != null);
assert wxSupport -> (gtk != null && wxGTK != null && pkgconfig != null);
assert wgetSupport -> (wget != null);
assert curlSupport -> (curl != null);

stdenv.mkDerivation rec {

  name = "bochs-${version}";
  version = "2.6.2";

  src = fetchurl {
    url = "http://downloads.sourceforge.net/project/bochs/bochs/${version}/${name}.tar.gz";
    sha256 = "042blm1xb9ig4fh2bv8nrrfpgkcxy4hq8yrkx7mrdpm5g4mvfwyr";
  };

  buildInputs = with stdenv.lib;
  [ libX11 mesa ]
  ++ optionals sdlSupport [ SDL ]
  ++ optionals termSupport [ readline ncurses ]
  ++ optionals wxSupport [ gtk wxGTK pkgconfig ]
  ++ optionals wgetSupport [ wget ]
  ++ optionals curlSupport [ curl ];

  configureFlags = ''
    --with-x11
    --with-term=${if termSupport then "yes" else "no"}
    --with-sdl=${if sdlSupport then "yes" else "no"}
    --with-svga=no
    --with-wx=${if wxSupport then "yes" else "no"}
    --enable-readline
    --enable-plugins=no
    --enable-disasm
    --enable-debugger
    --enable-ne2000
    --enable-e1000
    --enable-sb16
    --enable-voodoo
    --enable-usb
    --enable-pnic
'';

  meta = {
    description = "An open-source IA-32 (x86) PC emulator";
    longDescription = ''
    Bochs is an open-source (LGPL), highly portable IA-32 PC emulator, written in C++, that runs on most popular platforms. It includes emulation of the Intel x86 CPU, common I/O devices, and a custom BIOS.
    '';
    homepage = http://bochs.sourceforge.net/;
    license = stdenv.lib.licenses.lgpl2Plus;
    maintainers = [ stdenv.lib.maintainers.AndersonTorres ];
    platforms = stdenv.lib.platforms.linux;
  };
}

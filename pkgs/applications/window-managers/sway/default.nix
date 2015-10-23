{ lib, stdenv, fetchurl, makeWrapper, cmake, pkgconfig
, wayland, wlc, libxkbcommon, pixman, fontconfig, pcre, json_c, asciidoc, libxslt, dbus_libs
}:

stdenv.mkDerivation rec {
  name = "sway-${version}";
  version = "git-2015-10-16";

  src = fetchurl {
    url = "https://github.com/SirCmpwn/sway/archive/16e904634c65128610537bed7fcb16ac3bb45165.tar.gz";
    sha256 = "52d6c4b49fea69e2a2c1b44b858908b7736301bdb9ed483c294bc54bb40e872e";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ makeWrapper wayland wlc libxkbcommon pixman fontconfig pcre json_c asciidoc libxslt dbus_libs ];

  patchPhase = ''
    sed -i s@/etc/sway@$out/etc/sway@g CMakeLists.txt;
  '';

  makeFlags = "PREFIX=$(out)";
  installPhase = "PREFIX=$out make install";

  LD_LIBRARY_PATH = lib.makeLibraryPath [ wlc dbus_libs ];
  preFixup = ''
    wrapProgram $out/bin/sway \
      --prefix LD_LIBRARY_PATH : "${LD_LIBRARY_PATH}";
  '';

  meta = {
    description = "i3-compatible window manager for Wayland";
    homepage    = "http://swaywm.org";
    license     = lib.licenses.mit;
    platforms   = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ];
  };
}

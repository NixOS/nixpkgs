{ stdenv, fetchFromGitHub
, makeWrapper, cmake, pkgconfig, asciidoc, libxslt, docbook_xsl
, wayland, wlc, libxkbcommon, pixman, fontconfig, pcre, json_c, dbus_libs
, pango, cairo, libinput, libcap, xwayland, pam, gdk_pixbuf, libpthreadstubs
, libXdmcp
}:

let
  version = "0.13.0";
  # Temporary workaround (0.14.0 segfaults)
  wlc_009 = stdenv.lib.overrideDerivation wlc (oldAttrs: rec {
    name = "wlc-${version}";
    version = "0.0.9";

    src = fetchFromGitHub {
      owner = "Cloudef";
      repo = "wlc";
      rev = "v${version}";
      fetchSubmodules = true;
      sha256 = "1r6jf64gs7n9a8129wsc0mdwhcv44p8k87kg0714rhx3g2w22asg";
    };
  });
in stdenv.mkDerivation rec {
  name = "sway-${version}";

  src = fetchFromGitHub {
    owner = "Sircmpwn";
    repo = "sway";
    rev = "${version}";
    sha256 = "1vgk4rl51nx66yzpwg4yhnbj7wc30k5q0hh5lf8y0i1nvpal0p3q";
  };

  nativeBuildInputs = [
    makeWrapper cmake pkgconfig
    asciidoc libxslt docbook_xsl
  ];
  buildInputs = [
    wayland wlc_009 libxkbcommon pixman fontconfig pcre json_c dbus_libs
    pango cairo libinput libcap xwayland pam gdk_pixbuf libpthreadstubs
    libXdmcp
  ];

  patchPhase = ''
    sed -i s@/etc/sway@$out/etc/sway@g CMakeLists.txt;
  '';

  makeFlags = "PREFIX=$(out)";
  cmakeFlags = "-DVERSION=${version}";
  installPhase = "PREFIX=$out make install";

  LD_LIBRARY_PATH = stdenv.lib.makeLibraryPath [ wlc_009 dbus_libs ];
  preFixup = ''
    wrapProgram $out/bin/sway \
      --prefix LD_LIBRARY_PATH : "${LD_LIBRARY_PATH}";
  '';

  meta = with stdenv.lib; {
    description = "i3-compatible window manager for Wayland";
    homepage    = http://swaywm.org;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos ]; # Trying to keep it up-to-date.
  };
}

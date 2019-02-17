{ stdenv, fetchurl, pkgconfig, perl, autoconf, automake
, libX11, xorgproto, libXt, libXpm, libXft, libXtst, libXi
, libXrandr, fontconfig, freetype, readline
}:

stdenv.mkDerivation rec {
  name = "ratpoison-${version}";
  version = "1.4.9";

  src = fetchurl {
    url = "mirror://savannah/ratpoison/${name}.tar.xz";
    sha256 = "1wfir1gvh5h7izgvx2kd1pr2k7wlncd33zq7qi9s9k2y0aza93yr";
  };

  outputs = [ "out" "contrib" "man" "doc" "info" ];

  configureFlags = [
    # >=1.4.9 requires this even with readline in inputs
    "--enable-history"
  ];

  nativeBuildInputs = [ pkgconfig autoconf automake ];

  buildInputs =
    [ perl
      libX11 xorgproto libXt libXpm libXft libXtst libXi libXrandr
      fontconfig freetype readline ];

  postInstall = ''
    mkdir -p $contrib/{bin,share}
    mv $out/bin/rpws $contrib/bin
    mv $out/share/ratpoison $contrib/share
  '';

  meta = with stdenv.lib; {
    homepage = https://www.nongnu.org/ratpoison/;
    description = "Simple mouse-free tiling window manager";
    license = licenses.gpl2Plus;

    longDescription = ''
       Ratpoison is a simple window manager with no fat library
       dependencies, no fancy graphics, no window decorations, and no
       rodent dependence.  It is largely modelled after GNU Screen which
       has done wonders in the virtual terminal market.

       The screen can be split into non-overlapping frames.  All windows
       are kept maximized inside their frames to take full advantage of
       your precious screen real estate.

       All interaction with the window manager is done through keystrokes.
       Ratpoison has a prefix map to minimize the key clobbering that
       cripples Emacs and other quality pieces of software.
    '';

    platforms = platforms.unix;
    maintainers = [ maintainers.AndersonTorres ];
  };
}

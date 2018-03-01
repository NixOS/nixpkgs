{ stdenv, fetchFromGitHub, gnome3, libtool, intltool, pkgconfig, gtk3, hicolor-icon-theme, wrapGAppsHook } :

let
  version = "2.2";
in stdenv.mkDerivation {
  name = "gcolor3-${version}";

  src = fetchFromGitHub {
    owner = "hjdskes";
    repo = "gcolor3";
    rev = "v${version}";
    sha256 = "1rbahsi33pfggpj5cigy6wy5333g3rpm8v2q0b35c6m7pwhmf2gr";
  };

  nativeBuildInputs = [ gnome3.gnome-common libtool intltool pkgconfig hicolor-icon-theme wrapGAppsHook ];

  buildInputs = [ gtk3 ];

  configureScript = "./autogen.sh";

  # clang-4.0: error: argument unused during compilation: '-pthread'
  NIX_CFLAGS_COMPILE = stdenv.lib.optional stdenv.cc.isClang "-Wno-error=unused-command-line-argument";

  meta = {
    description = "A simple color chooser written in GTK3";
    homepage = https://hjdskes.github.io/projects/gcolor3/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ jtojnar ];
    platforms = stdenv.lib.platforms.unix;
  };
}

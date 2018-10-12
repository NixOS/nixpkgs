{ stdenv, fetchurl, makeWrapper, pkgconfig, gtk3, librsvg }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "howl-${version}";
  version = "0.5.3";

  # Use the release tarball containing pre-downloaded dependencies sources
  src = fetchurl {
    url = "https://github.com/howl-editor/howl/releases/download/0.5.3/howl-0.5.3.tgz";
    sha256 = "0gnc8vr5h8mwapbcqc1zr9la62rb633awyqgy8q7pwjpiy85a03v";
  };

  sourceRoot = "./howl-${version}/src";

  # The Makefile uses "/usr/local" if not explicitly overridden
  installFlags = [ "PREFIX=$(out)" ];

  nativeBuildInputs = [ makeWrapper pkgconfig ];
  buildInputs = [ gtk3 librsvg ];
  enableParallelBuilding = true;

  # Required for the program to properly load its SVG assets
  postInstall = ''
    wrapProgram $out/bin/howl \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE"
  '';

  meta = {
    homepage = https://howl.io/;
    description = "A general purpose, fast and lightweight editor with a keyboard-centric minimalistic user interface";
    license = licenses.mit;
    maintainers = with maintainers; [ pacien ];

    # LuaJIT and Howl builds fail for x86_64-darwin and aarch64-linux respectively
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}


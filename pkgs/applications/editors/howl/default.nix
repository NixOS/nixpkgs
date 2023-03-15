{ lib, stdenv, fetchurl, makeWrapper, pkg-config, gtk3, librsvg }:

stdenv.mkDerivation rec {
  pname = "howl";
  version = "0.6";

  # Use the release tarball containing pre-downloaded dependencies sources
  src = fetchurl {
    url = "https://github.com/howl-editor/howl/releases/download/${version}/howl-${version}.tgz";
    sha256 = "1qc58l3rkr37cj6vhf8c7bnwbz93nscyraz7jxqwjq6k4gj0cjw3";
  };

  sourceRoot = "./howl-${version}/src";

  # The Makefile uses "/usr/local" if not explicitly overridden
  installFlags = [ "PREFIX=$(out)" ];

  nativeBuildInputs = [ makeWrapper pkg-config ];
  buildInputs = [ gtk3 librsvg ];
  enableParallelBuilding = true;

  # Required for the program to properly load its SVG assets
  postInstall = ''
    wrapProgram $out/bin/howl \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE"
  '';

  meta = with lib; {
    homepage = "https://howl.io/";
    description = "A general purpose, fast and lightweight editor with a keyboard-centric minimalistic user interface";
    license = licenses.mit;
    maintainers = with maintainers; [ pacien ];

    # LuaJIT and Howl builds fail for x86_64-darwin and aarch64-linux respectively
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}


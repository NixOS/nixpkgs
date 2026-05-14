{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  pkg-config,
  gtk3,
  librsvg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "howl";
  version = "0.6";

  # Use the release tarball containing pre-downloaded dependencies sources
  src = fetchurl {
    url = "https://github.com/howl-editor/howl/releases/download/${finalAttrs.version}/howl-${finalAttrs.version}.tgz";
    sha256 = "1qc58l3rkr37cj6vhf8c7bnwbz93nscyraz7jxqwjq6k4gj0cjw3";
  };

  sourceRoot = "howl-${finalAttrs.version}/src";

  # The Makefile uses "/usr/local" if not explicitly overridden
  installFlags = [ "PREFIX=$(out)" ];

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];
  buildInputs = [
    gtk3
    librsvg
  ];
  enableParallelBuilding = true;

  # Required for the program to properly load its SVG assets
  postInstall = ''
    wrapProgram $out/bin/howl \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE"
  '';

  meta = {
    homepage = "https://howl.io/";
    description = "General purpose, fast and lightweight editor with a keyboard-centric minimalistic user interface";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ euxane ];
    mainProgram = "howl";

    # LuaJIT and Howl builds fail for x86_64-darwin and aarch64-linux respectively
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
})

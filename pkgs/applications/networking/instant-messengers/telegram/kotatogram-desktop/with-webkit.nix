{
  stdenv,
  lib,
  kotatogram-desktop,
  glib-networking,
  webkitgtk_6_0,
  makeWrapper,
}:

stdenv.mkDerivation {
  pname = "${kotatogram-desktop.pname}-with-webkit";
  version = kotatogram-desktop.version;
  nativeBuildInputs = [ makeWrapper ];
  dontUnpack = true;
  installPhase = ''
    mkdir -p $out
    cp -r ${kotatogram-desktop}/share $out
  '';
  postFixup = ''
    mkdir -p $out/bin
    makeWrapper ${kotatogram-desktop}/bin/kotatogram-desktop $out/bin/kotatogram-desktop \
      --prefix GIO_EXTRA_MODULES : ${glib-networking}/lib/gio/modules \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ webkitgtk_6_0 ]}
  '';
  meta = kotatogram-desktop.meta // {
    platforms = lib.platforms.linux;
  };
}

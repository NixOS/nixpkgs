{ stdenv, lib, kotatogram-desktop, glib-networking, webkitgtk_4_1, makeBinaryWrapper }:

stdenv.mkDerivation {
  pname = "${kotatogram-desktop.pname}-with-webkit";
  version = kotatogram-desktop.version;
  nativeBuildInputs = [ makeBinaryWrapper ];
  dontUnpack = true;
  installPhase = ''
    mkdir -p $out
    cp -r ${kotatogram-desktop}/share $out
    substituteInPlace $out/share/dbus-1/services/* --replace-fail ${kotatogram-desktop} $out
  '';
  postFixup = ''
    mkdir -p $out/bin
    makeBinaryWrapper {${kotatogram-desktop},$out}/bin/${kotatogram-desktop.meta.mainProgram} \
      --inherit-argv0 \
      --prefix GIO_EXTRA_MODULES : ${glib-networking}/lib/gio/modules \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ webkitgtk_4_1 ]}
  '';
  meta = kotatogram-desktop.meta // {
    platforms = lib.platforms.linux;
  };
}

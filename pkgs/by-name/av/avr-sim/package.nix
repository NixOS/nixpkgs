{
  lib,
  stdenv,
  fetchzip,
  lazarus,
  fpc,
  pango,
  cairo,
  glib,
  atk,
  gtk2,
  libX11,
  gdk-pixbuf,
}:
stdenv.mkDerivation rec {
  pname = "avr-sim";
  version = "2.8";

  # Unfortunately old releases get removed:
  # http://www.avr-asm-tutorial.net/avr_sim/avr_sim-download.html
  # Therefore, fallback to an archive.org snapshot
  src = fetchzip {
    urls = [
      "http://www.avr-asm-tutorial.net/avr_sim/28/avr_sim_28_lin_src.zip"
      "https://web.archive.org/web/20231129125754/http://www.avr-asm-tutorial.net/avr_sim/28/avr_sim_28_lin_src.zip"
    ];
    hash = "sha256-7MgUzMs+l+3RVUbORAWyU1OUpgrKIeWhS+ObgRJtOHc=";
  };

  nativeBuildInputs = [lazarus fpc];

  buildInputs = [pango cairo glib atk gtk2 libX11 gdk-pixbuf];

  NIX_LDFLAGS = "--as-needed -rpath ${lib.makeLibraryPath buildInputs}";

  buildPhase = ''
    runHook preBuild

    lazbuild --lazarusdir=${lazarus}/share/lazarus --build-mode=Release avr_sim.lpi

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    cp avr_sim $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    description = "AVR assembler simulator for the stepwise execution of assembler source code - with many extras";
    homepage = "http://www.avr-asm-tutorial.net/avr_sim/index_en.html";
    license = licenses.unfree;
    platforms = platforms.unix;
    maintainers = with maintainers; [ameer];
  };
}

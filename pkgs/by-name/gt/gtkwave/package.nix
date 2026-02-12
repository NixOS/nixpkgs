{
  bzip2,
  fetchurl,
  glib,
  gperf,
  gtk3,
  gtk-mac-integration,
  judy,
  lib,
  pkg-config,
  stdenv,
  tcl,
  tk,
  wrapGAppsHook3,
  xz,
  desktopToDarwinBundle,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gtkwave";
  version = "3.3.126";

  src = fetchurl {
    url = "mirror://sourceforge/gtkwave/gtkwave-gtk3-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-llAZ10gpdGtdHTgqnPHiciRskRAdDhMfDaUSyUulgWo=";
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    desktopToDarwinBundle
  ];
  buildInputs = [
    bzip2
    glib
    gperf
    gtk3
    judy
    tcl
    tk
    xz
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin gtk-mac-integration;

  configureFlags = [
    "--with-tcl=${tcl}/lib"
    "--with-tk=${tk}/lib"
    "--enable-judy"
    "--enable-gtk3"
  ];

  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mv $out/bin/.gtkwave-wrapped $out/Applications/GTKWave.app/Contents/MacOS/.gtkwave-wrapped
    makeWrapper $out/Applications/GTKWave.app/Contents/MacOS/.gtkwave-wrapped $out/Applications/GTKWave.app/Contents/MacOS/GTKWave \
      --inherit-argv0 \
      "''${gappsWrapperArgs[@]}"
    ln -sf $out/Applications/GTKWave.app/Contents/MacOS/GTKWave $out/bin/gtkwave
  '';

  meta = {
    description = "VCD/Waveform viewer for Unix and Win32";
    homepage = "https://gtkwave.sourceforge.net";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      thoughtpolice
      jiegec
      jleightcap
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})

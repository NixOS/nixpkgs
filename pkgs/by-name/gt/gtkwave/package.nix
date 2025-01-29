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

stdenv.mkDerivation rec {
  pname = "gtkwave";
  version = "3.3.121";

  src = fetchurl {
    url = "mirror://sourceforge/gtkwave/${pname}-gtk3-${version}.tar.gz";
    sha256 = "sha256-VKpFeI1tUq+2WcOu8zWq/eDvLImQp3cPjqpk5X8ic0Y=";
  };

  nativeBuildInputs =
    [
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
  ] ++ lib.optional stdenv.hostPlatform.isDarwin gtk-mac-integration;

  # fix compilation under Darwin
  # remove these patches upon next release
  # https://github.com/gtkwave/gtkwave/pull/136
  patches = [
    ./0001-Fix-detection-of-quartz-in-gdk-3.0-target.patch
    ./0002-Check-GDK_WINDOWING_X11-macro-when-using-GtkPlug.patch
  ];

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
}

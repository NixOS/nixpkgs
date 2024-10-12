{ bzip2
, fetchurl
, glib
, gperf
, gtk3
, gtk-mac-integration
, judy
, lib
, pkg-config
, stdenv
, tcl
, tk
, wrapGAppsHook3
, xz
}:

stdenv.mkDerivation rec {
  pname = "gtkwave";
  version = "3.3.120";

  src = fetchurl {
    url = "mirror://sourceforge/gtkwave/${pname}-gtk3-${version}.tar.gz";
    sha256 = "sha256-XalIY/suXYjMAZ4r/cZ2AiOYETiUtYXYZOEcqDQbJNg=";
  };

  nativeBuildInputs = [ pkg-config wrapGAppsHook3 ];
  buildInputs = [ bzip2 glib gperf gtk3 judy tcl tk xz ]
    ++ lib.optional stdenv.hostPlatform.isDarwin gtk-mac-integration;

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

  meta = {
    description = "VCD/Waveform viewer for Unix and Win32";
    homepage = "https://gtkwave.sourceforge.net";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ thoughtpolice jiegec jleightcap ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}

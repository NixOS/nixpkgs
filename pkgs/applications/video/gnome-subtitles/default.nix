{ stdenv
, lib
, fetchFromGitLab
, autoconf
, autoreconfHook
, automake
, gettext
, pkg-config
, intltool
, itstool
, libtool
, mono5
, yelp-tools
, wrapGAppsHook
, enchant2
, gnome
, glib
, gtk3
, gtk-doc
, gtk-sharp-3_0
, gtkspell3
, gst_all_1
, libxml2
}:

stdenv.mkDerivation rec {
  pname = "gnome-subtitles";
  version = "1.7.2";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = pname;
    rev = "${pname}-${version}";
    hash = "sha256-/Rx0Rck3NdaOALoIyFHMwV1Obf+TjfyO/BBIwlm1KxY=";
  };

  nativeBuildInputs = [
    wrapGAppsHook
    gtk-doc
    autoreconfHook
    autoconf
    automake
    gettext
    mono5
    libtool
    intltool
    itstool
    pkg-config
    yelp-tools
  ];

  buildInputs = [
    enchant2
    gtk3
    glib
    libxml2
    gtk-sharp-3_0
    gtkspell3
    gnome.gnome-common
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    (gst-plugins-good.override {
      gtkSupport = true;
    })
    gst-plugins-bad
    gst-plugins-ugly
  ]);

  preConfigure = ''
    intltoolize
  '';

  preFixup = ''
      gappsWrapperArgs+=(
        --prefix MONO_PATH : "${gtk-sharp-3_0}/lib/mono/gtk-sharp-3.0"
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ enchant2 glib gtk3 ]}
      )
  '';

  meta = with lib; {
    description = "Subtitle editor for the GNOME desktop";
    homepage = "http://gnomesubtitles.org/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ dasj19 ];
    platforms = platforms.unix;
  };
}

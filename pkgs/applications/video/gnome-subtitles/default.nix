{ stdenv
, lib
, fetchFromGitLab
, autoreconfHook
, pkg-config
, intltool
, itstool
, mono
, yelp-tools
, wrapGAppsHook
, enchant2
, glib
, gtk3
, gtk-doc
, gtk-sharp-3_0
, gst_all_1
, libxml2
}:

stdenv.mkDerivation rec {
  pname = "gnome-subtitles";
  version = "1.6";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "1crmmcx32i6ca7dlr3xhnc7vgv9jhlpwh6hxhv2fl1x1zbasf42z";
  };

  nativeBuildInputs = [
    wrapGAppsHook
    gtk-doc
    autoreconfHook
    mono
    intltool
    itstool
    pkg-config
    yelp-tools
  ];

  buildInputs = [
    enchant2
    gtk3
    libxml2
    glib
    gtk-sharp-3_0
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    (gst-plugins-good.override {
      gtkSupport = true;
    })
    gst-plugins-bad
  ]);

  preConfigure = ''
    intltoolize
  '';

  # The unreleased master branch looks after libenchant2 by default.
  # So this would not be needed in the next release.
  prePatch = ''
    substituteInPlace src/GnomeSubtitles/Execution/gnome-subtitles.exe.config \
      --replace "libenchant.so.1" "libenchant-2.so.2"
  '';

  preFixup =
    let
      libPath = lib.makeLibraryPath [
        enchant2
        glib
        gtk3
      ];
    in
    ''
      gappsWrapperArgs+=(
        --prefix MONO_PATH : "${gtk-sharp-3_0}/lib/mono/gtk-sharp-3.0"
        --prefix LD_LIBRARY_PATH : "${libPath}"
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

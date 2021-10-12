{ lib
, stdenv
, fetchFromGitHub
, perlPackages
, wrapGAppsHook
, imagemagick
, gdk-pixbuf
, librsvg
, hicolor-icon-theme
, procps
, libwnck
, libappindicator-gtk3
}:

let
  perlModules = with perlPackages; [
      # Not sure if these are needed
      # Gnome2 Gnome2Canvas Gnome2VFS Gtk2AppIndicator Gtk2Unique
      ImageMagick
      Cairo
      FileBaseDir
      FileWhich
      FileCopyRecursive
      XMLSimple
      XMLTwig
      XMLParser
      SortNaturally
      LocaleGettext
      ProcProcessTable
      X11Protocol
      ProcSimple
      ImageExifTool
      JSON
      JSONMaybeXS
      NetOAuth
      PathClass
      LWP
      LWPProtocolHttps
      NetDBus
      TryTiny
      WWWMechanize
      HTTPMessage
      HTTPDate
      HTMLForm
      HTMLParser
      HTMLTagset
      HTTPCookies
      EncodeLocale
      URI
      CarpAlways
      GlibObjectIntrospection
      NumberBytesHuman
      CairoGObject
      Readonly
      Gtk3ImageView
      Gtk3
      Glib
      Pango
      GooCanvas2
      GooCanvas2CairoTypes
      commonsense
      TypesSerialiser
    ];
in
stdenv.mkDerivation rec {
  pname = "shutter";
  version = "0.99";

  src = fetchFromGitHub {
    owner = "shutter-project";
    repo = "shutter";
    rev = "v${version}";
    sha256 = "sha256-n5M+Ggk8ulJQMWjAW+/fC8fbqiBGzsx6IXlYxvf8utA=";
  };

  nativeBuildInputs = [ wrapGAppsHook ];
  buildInputs = [
    perlPackages.perl
    procps
    gdk-pixbuf
    librsvg
    libwnck
    libappindicator-gtk3
  ] ++ perlModules;

  makeFlags = [
    "prefix=${placeholder "out"}"
  ];

  postPatch = ''
    patchShebangs po2mo.sh
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --set PERL5LIB ${perlPackages.makePerlPath perlModules} \
      --prefix PATH : ${lib.makeBinPath [ imagemagick ] } \
      --suffix XDG_DATA_DIRS : ${hicolor-icon-theme}/share \
      --set GDK_PIXBUF_MODULE_FILE $GDK_PIXBUF_MODULE_FILE
    )
  '';

  meta = with lib; {
    description = "Screenshot and annotation tool";
    homepage = "https://shutter-project.org/";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
  };
}

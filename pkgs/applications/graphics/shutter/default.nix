{ lib
, stdenv
, fetchFromGitHub
, perlPackages
, wrapGAppsHook3
, imagemagick
, gdk-pixbuf
, librsvg
, hicolor-icon-theme
, procps
, libwnck
, libappindicator-gtk3
, xdg-utils
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
  version = "0.99.2";

  src = fetchFromGitHub {
    owner = "shutter-project";
    repo = "shutter";
    rev = "v${version}";
    sha256 = "sha256-o95skSr6rszh0wsHQTpu1GjqCDmde7aygIP+i4XQW9A=";
  };

  nativeBuildInputs = [ wrapGAppsHook3 ];
  buildInputs = [
    perlPackages.perl
    procps
    gdk-pixbuf
    librsvg
    libwnck
    libappindicator-gtk3
    hicolor-icon-theme
  ] ++ perlModules;

  makeFlags = [
    "prefix=${placeholder "out"}"
  ];

  postPatch = ''
    patchShebangs po2mo.sh
  '';

  preFixup = ''
    # make xdg-open overrideable at runtime
    gappsWrapperArgs+=(
      --set PERL5LIB ${perlPackages.makePerlPath perlModules} \
      --prefix PATH : ${lib.makeBinPath [ imagemagick ] }
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ] }
    )
  '';

  meta = with lib; {
    description = "Screenshot and annotation tool";
    mainProgram = "shutter";
    homepage = "https://shutter-project.org/";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
  };
}

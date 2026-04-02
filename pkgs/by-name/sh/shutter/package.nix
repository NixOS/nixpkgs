{
  lib,
  stdenv,
  fetchFromGitHub,
  perlPackages,
  wrapGAppsHook3,
  imagemagick,
  gdk-pixbuf,
  librsvg,
  hicolor-icon-theme,
  procps,
  libwnck,
  libappindicator-gtk3,
  xdg-utils,
}:

let
  perlModules = with perlPackages; [
    Cairo
    CairoGObject
    CarpAlways
    commonsense
    EncodeLocale
    FileBaseDir
    FileCopyRecursive
    FileWhich
    Glib
    GlibObjectIntrospection
    GooCanvas2
    GooCanvas2CairoTypes
    Gtk3
    Gtk3ImageView
    HTMLForm
    HTMLParser
    HTMLTagset
    HTTPCookies
    HTTPDate
    HTTPMessage
    ImageExifTool
    ImageMagick
    JSON
    JSONMaybeXS
    LocaleGettext
    LWP
    LWPProtocolHttps
    Moo
    NetDBus
    NumberBytesHuman
    Pango
    PathClass
    ProcProcessTable
    ProcSimple
    Readonly
    SortNaturally
    SubQuote
    TryTiny
    TypesSerialiser
    URI
    X11Protocol
    XMLParser
    XMLSimple
    XMLTwig
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "shutter";
  version = "0.99.6";

  src = fetchFromGitHub {
    owner = "shutter-project";
    repo = "shutter";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-2wRPmTpFfgU8xW9Fyn1+TMowcKm3pukT1ck06IWPiGo=";
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
  ]
  ++ perlModules;

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
      --prefix PATH : ${lib.makeBinPath [ imagemagick ]}
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]}
    )
  '';

  meta = {
    description = "Screenshot and annotation tool";
    mainProgram = "shutter";
    homepage = "https://shutter-project.org/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.bjornfor ];
  };
})

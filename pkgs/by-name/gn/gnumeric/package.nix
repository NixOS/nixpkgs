{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  intltool,
  libxml2,
  perlPackages,
  goffice,
  gnome,
  adwaita-icon-theme,
  wrapGAppsHook3,
  glib,
  gtk3,
  bison,
  python3Packages,
  itstool,
  autoreconfHook,
  gtk-doc,
  fetchFromGitLab,
  gettext,
  yelp-tools,
}:

let
  inherit (python3Packages) python pygobject3;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gnumeric";
  version = "1.12.59";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gnumeric";
    tag = "GNUMERIC_${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-7xCDOqPx3QLDHLoKG46e8te4smSFrLOgCcWkiJXGjDQ=";
  };

  preConfigure = ''
    ./autogen.sh
  '';

  configureFlags = [ "--disable-component" ];

  nativeBuildInputs = [
    autoreconfHook
    gettext
    gtk-doc
    yelp-tools
    pkg-config
    intltool
    bison
    itstool
    glib # glib-compile-resources
    libxml2 # xmllint
    python.pythonOnBuildForHost
    wrapGAppsHook3
  ];

  # ToDo: optional libgda, introspection?
  # TODO: fix Perl plugin when cross-compiling
  buildInputs = [
    goffice
    gtk3
    adwaita-icon-theme
    python
    pygobject3
  ]
  ++ (with perlPackages; [
    perl
    XMLParser
  ]);

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace configure.ac \
      --replace-fail 'GLIB_COMPILE_RESOURCES=' 'GLIB_COMPILE_RESOURCES="glib-compile-resources"#'
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnumeric";
      versionPolicy = "odd-unstable";
    };
  };

  meta = {
    description = "GNOME Office Spreadsheet";
    license = lib.licenses.gpl2Plus;
    homepage = "http://projects.gnome.org/gnumeric/";
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.vcunat ];
  };
})

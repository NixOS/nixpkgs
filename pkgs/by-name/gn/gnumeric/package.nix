{
  lib,
  stdenv,
  fetchurl,
  autoconf,
  automake,
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
}:

let
  inherit (python3Packages) python pygobject3;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gnumeric";
  version = "1.12.59";

  src = fetchurl {
    url = "mirror://gnome/sources/gnumeric/${lib.versions.majorMinor finalAttrs.version}/gnumeric-${finalAttrs.version}.tar.xz";
    sha256 = "yzdQsXbWQflCPfchuDFljIKVV1UviIf+34pT2Qfs61E=";
  };

  configureFlags = [ "--disable-component" ];

  nativeBuildInputs = [
    autoconf
    automake
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

  meta = with lib; {
    description = "GNOME Office Spreadsheet";
    license = lib.licenses.gpl2Plus;
    homepage = "http://projects.gnome.org/gnumeric/";
    platforms = platforms.unix;
    maintainers = [ maintainers.vcunat ];
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  autoconf,
  automake,
  libtool,
  gettext,
  pkg-config,
  wxwidgets_3_2,
  boost,
  icu,
  lucenepp,
  asciidoc,
  libxslt,
  xmlto,
  gtk3,
  gtkspell3,
  pugixml,
  nlohmann_json,
  hicolor-icon-theme,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "poedit";
  version = "3.9";

  src = fetchFromGitHub {
    owner = "vslavik";
    repo = "poedit";
    rev = "v${finalAttrs.version}-oss";
    hash = "sha256-N/o57n624b+StXrT6jBxEFSGElcHdV6wrf/Y2JbA55k=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    asciidoc
    wrapGAppsHook3
    libxslt
    xmlto
    boost
    libtool
    pkg-config
  ];

  buildInputs = [
    lucenepp
    nlohmann_json
    wxwidgets_3_2
    icu
    pugixml
    gtk3
    gtkspell3
    hicolor-icon-theme
  ];

  propagatedBuildInputs = [ gettext ];

  preConfigure = "
    patchShebangs bootstrap
    ./bootstrap
  ";

  configureFlags = [
    "--without-cld2"
    "--without-cpprest"
    "--with-boost-libdir=${boost.out}/lib"
    "CPPFLAGS=-I${nlohmann_json}/include/nlohmann/"
    "LDFLAGS=-llucene++"
  ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : "${lib.makeBinPath [ gettext ]}")
  '';

  enableParallelBuilding = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "(.*)-oss"
    ];
  };

  meta = {
    description = "Cross-platform gettext catalogs (.po files) editor";
    mainProgram = "poedit";
    homepage = "https://www.poedit.net/";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ dasj19 ];
    # configure: error: GTK+ build of wxWidgets is required
    broken = stdenv.hostPlatform.isDarwin;
  };
})

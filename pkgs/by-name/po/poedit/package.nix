{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  libtool,
  gettext,
  pkg-config,
  wxGTK32,
  boost177,
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
  cld2,
  cpprest,
  libsecret,
}:

stdenv.mkDerivation rec {
  pname = "poedit";
  version = "3.6.1";

  src = fetchFromGitHub {
    owner = "vslavik";
    repo = "poedit";
    rev = "v${version}-oss";
    hash = "sha256-R3X1bWcbIJX2a1qf7hNuKNV9rp3TzINmtCaO7bkHze4=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    asciidoc
    wrapGAppsHook3
    libxslt
    xmlto
    boost177
    libtool
    pkg-config
  ];

  buildInputs = [
    lucenepp
    nlohmann_json
    wxGTK32
    icu
    pugixml
    gtk3
    gtkspell3
    hicolor-icon-theme
    cld2
    cpprest
    libsecret
  ];

  propagatedBuildInputs = [ gettext ];

  preConfigure = ''
    patchShebangs bootstrap
    ./bootstrap

    configureFlagsArray+=(
      "CPPFLAGS=-I${nlohmann_json}/include/nlohmann/ -I${cpprest}/include/"
    )
  '';

  configureFlags = [
    "--with-boost-libdir=${boost177.out}/lib"
    "LDFLAGS=-llucene++"
    "--with-cpprest"
  ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : "${lib.makeBinPath [ gettext ]}")
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Cross-platform gettext catalogs (.po files) editor";
    mainProgram = "poedit";
    homepage = "https://www.poedit.net/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dasj19 ];
    # configure: error: GTK+ build of wxWidgets is required
    broken = stdenv.hostPlatform.isDarwin;
  };
}

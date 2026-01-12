{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  python3,
  wrapGAppsHook3,
  gtkmm3,
  gtksourceview4,
  gtksourceviewmm,
  gspell,
  libxmlxx,
  sqlite,
  curl,
  libuchardet,
  spdlog,
  fribidi,
  vte,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cherrytree";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "giuspen";
    repo = "cherrytree";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YsxhjATadOielthdPyfNrPCL9nhFny00WugDHmRk03k=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
    wrapGAppsHook3
  ];

  buildInputs = [
    gtkmm3
    gtksourceview4
    gtksourceviewmm
    gspell
    libxmlxx
    sqlite
    curl
    libuchardet
    spdlog
    fribidi
    vte
  ];

  meta = {
    description = "Hierarchical note taking application";
    mainProgram = "cherrytree";
    longDescription = ''
      Cherrytree is an hierarchical note taking application, featuring rich
      text, syntax highlighting and powerful search capabilities. It organizes
      all information in units called "nodes", as in a tree, and can be very
      useful to store any piece of information, from tables and links to
      pictures and even entire documents. All those little bits of information
      you have scattered around your hard drive can be conveniently placed into
      a Cherrytree document where you can easily find it.
    '';
    homepage = "https://www.giuspen.com/cherrytree";
    changelog = "https://raw.githubusercontent.com/giuspen/cherrytree/${finalAttrs.version}/changelog.txt";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})

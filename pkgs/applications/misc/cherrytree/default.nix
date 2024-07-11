{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, python3
, wrapGAppsHook3
, gtkmm3
, gtksourceview
, gtksourceviewmm
, gspell
, libxmlxx
, sqlite
, curl
, libuchardet
, spdlog
, fribidi
, vte
}:

stdenv.mkDerivation rec {
  pname = "cherrytree";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "giuspen";
    repo = "cherrytree";
    rev = "refs/tags/v${version}";
    hash = "sha256-gDDFrF1yK6mWwkb3KJVRj6P5aiH1pQ/xL17XwVb4rfk=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
    wrapGAppsHook3
  ];

  buildInputs = [
    gtkmm3
    gtksourceview
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

  meta = with lib; {
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
    changelog = "https://raw.githubusercontent.com/giuspen/cherrytree/${version}/changelog.txt";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}

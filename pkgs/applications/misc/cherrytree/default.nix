{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, python3
, wrapGAppsHook
, gtkmm3
, gtksourceview
, gtksourceviewmm
, gspell
, libxmlxx
, sqlite
, curl
, libuchardet
, spdlog
<<<<<<< HEAD
, fribidi
, vte
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "cherrytree";
<<<<<<< HEAD
  version = "0.99.56";
=======
  version = "0.99.49";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "giuspen";
    repo = "cherrytree";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-kDbUn81YfSMAX7FKcw+nDSrsNvrhOX0+NmgZUYNqCqQ=";
=======
    sha256 = "sha256-p7kiOxy4o0RwmN3LFfLSpkz08KcYYMVxVAEUvAX1KEA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
    wrapGAppsHook
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
<<<<<<< HEAD
    fribidi
    vte
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  meta = with lib; {
    description = "An hierarchical note taking application";
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
  };
}

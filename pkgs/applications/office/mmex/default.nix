{ stdenv, fetchgit, sqlite, wxGTK30, gettext, wrapGAppsHook }:


let
  version = "1.3.3";
in
  stdenv.mkDerivation {
    pname = "money-manager-ex";
    inherit version;

    src = fetchgit {
      url = "https://github.com/moneymanagerex/moneymanagerex.git";
      rev = "refs/tags/v${version}";
      sha256 = "0r4n93z3scv0i0zqflsxwv7j4yl8jy3gr0m4l30y1q8qv0zj9n74";
    };

    nativeBuildInputs = [
      wrapGAppsHook
    ];

    buildInputs = [
      gettext
      sqlite
      wxGTK30
      wxGTK30.gtk
    ];

    meta = {
      description = "Easy-to-use personal finance software";
      homepage = https://www.moneymanagerex.org/;
      license = stdenv.lib.licenses.gpl2Plus;
      maintainers = with stdenv.lib.maintainers; [viric];
      platforms = with stdenv.lib.platforms; linux;
    };
  }

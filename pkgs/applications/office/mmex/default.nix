{ stdenv, fetchFromGitHub, sqlite, wxGTK30, gettext }:


let
  version = "1.3.3";
in
  stdenv.mkDerivation {
    name = "money-manager-ex-${version}";

    src = fetchFromGitHub {
      owner = "moneymanagerex";
      repo = "moneymanagerex";
      rev = "refs/tags/v${version}";
      sha256 = "1yh4mblj1fvkxw0p3l0jmfqjdzg7s4lxkk3kvvskmgj19i2sc1j0";
    };

    buildInputs = [ sqlite wxGTK30 gettext ];

    meta = {
      description = "Easy-to-use personal finance software";
      homepage = http://www.moneymanagerex.org/;
      license = stdenv.lib.licenses.gpl2Plus;
      maintainers = with stdenv.lib.maintainers; [viric];
      platforms = with stdenv.lib.platforms; linux;
    };
  }

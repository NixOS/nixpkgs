{ stdenv, fetchgit, sqlite, wxGTK30, gettext }:


let
  version = "1.3.1";
in
  stdenv.mkDerivation {
    name = "money-manager-ex-${version}";

    src = fetchgit {
      url = "https://github.com/moneymanagerex/moneymanagerex.git";
      rev = "refs/tags/v${version}";
      sha256 = "1cmwmvlzg7r85qq23lbbmq2y91vhf9f5pblpja5ph98bsd218pc0";
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

{ stdenv, fetchgit, sqlite, wxGTK30, gettext }:


let
  version = "1.2.7";
in
  stdenv.mkDerivation {
    name = "money-manager-ex-${version}";

    src = fetchgit {
      url = "https://github.com/moneymanagerex/moneymanagerex.git";
      rev = "refs/tags/v${version}";
      sha256 = "0d6jcsj3m3b9mj68vfwr7dn67dws11p0pdys3spyyiv1464vmywi";
    };

    preConfigure = ''
      export CFLAGS="-I`pwd`/include"
      export CXXFLAGS="$CFLAGS"
    '';

    buildInputs = [ sqlite wxGTK30 gettext ];

    meta = {
      description = "Easy-to-use personal finance software";
      homepage = http://www.moneymanagerex.org/;
      license = stdenv.lib.licenses.gpl2Plus;
      maintainers = with stdenv.lib.maintainers; [viric];
      platforms = with stdenv.lib.platforms; linux;
    };
  }

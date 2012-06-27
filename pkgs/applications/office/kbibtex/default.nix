{ stdenv, fetchurl, kdelibs, libxslt, popplerQt4 }:

stdenv.mkDerivation rec {
  pname = "kbibtex";
  version = "0.4";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://download.gna.org/${pname}/${version}/${name}.tar.bz2";
    sha256 = "1hq0az0dp96195z26wjfwj9ynd57pfv13f1xcl5vbsswcjfrczws";
  };

  patchPhase = ''
    sed -e '25i#include <QModelIndex>' -i src/gui/preferences/settingsabstractwidget.h
    '';

  buildInputs = [ kdelibs libxslt popplerQt4 ];
}

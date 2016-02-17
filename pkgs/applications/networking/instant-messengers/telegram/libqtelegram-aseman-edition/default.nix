{ stdenv, fetchFromGitHub
, qtbase, qtmultimedia, qtquick1 }:

stdenv.mkDerivation rec {
  name = "libqtelegram-aseman-edition-${version}";
  version = "6.0";

  src = fetchFromGitHub {
    owner = "Aseman-Land";
    repo = "libqtelegram-aseman-edition";
    rev = "v${version}";
    sha256 = "17hlxf43xwic8m06q3gwbxjpvz31ks6laffjw6ny98d45zfnfwra";
  };

  buildInputs = [ qtbase qtmultimedia qtquick1 ];
  enableParallelBuild = true;

  patchPhase = ''
    substituteInPlace libqtelegram-ae.pro --replace "/libqtelegram-ae" ""
    substituteInPlace libqtelegram-ae.pro --replace "/\$\$LIB_PATH" ""
  '';

  configurePhase = ''
    qmake -r PREFIX=$out
  '';

  meta = with stdenv.lib; {
    description = "A fork of libqtelegram by Aseman, using qmake";
    homepage = src.meta.homepage;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ maintainers.profpatsch ];
  };

}

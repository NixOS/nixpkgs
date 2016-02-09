{ stdenv, fetchFromGitHub
, qtbase, qtmultimedia, qtquick1
, libqtelegram-aseman-edition }:

stdenv.mkDerivation rec {
  name = "telegram-qml-${version}";
  version = "0.9.1-stable";

  src = fetchFromGitHub {
    owner = "Aseman-Land";
    repo = "TelegramQML";
    rev = "v${version}";
    sha256 = "077j06lfr6qccqv664hn0ln023xlh5cfm50kapjc2inapxj2yqmn";
  };

  buildInputs = [ qtbase qtmultimedia qtquick1 libqtelegram-aseman-edition ];
  enableParallelBuild = true;

  patchPhase = ''
    substituteInPlace telegramqml.pro --replace "/\$\$LIB_PATH" ""
    substituteInPlace telegramqml.pro --replace "INSTALL_HEADERS_PREFIX/telegramqml" "INSTALL_HEADERS_PREFIX"
  '';

  configurePhase = ''
    qmake -r PREFIX=$out BUILD_MODE+=lib
  '';

  meta = with stdenv.lib; {
    description = "Telegram API tools for QtQml and Qml";
    homepage = src.meta.homepage;
    license = stdenv.lib.licenses.gpl3;
    maintainer = [ maintainers.profpatsch ];
  };

}

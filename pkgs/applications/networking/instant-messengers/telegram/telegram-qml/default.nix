{ stdenv, fetchFromGitHub
, qtbase, qtmultimedia, qtquick1
, libqtelegram-aseman-edition }:

stdenv.mkDerivation rec {
  name = "telegram-qml-${meta.version}";

  src = fetchFromGitHub {
    owner = "Aseman-Land";
    repo = "TelegramQML";
    rev = "v${meta.version}";
    sha256 = "0j8vn845f2virvddk9yjbljy6vkr9ikyn6iy7hpj8nvr2xls3499";
  };

  propagatedBuildInputs = [ qtbase qtmultimedia qtquick1 libqtelegram-aseman-edition ];
  enableParallelBuilding = true;

  patchPhase = ''
    substituteInPlace telegramqml.pro --replace "/\$\$LIB_PATH" ""
    substituteInPlace telegramqml.pro --replace "INSTALL_HEADERS_PREFIX/telegramqml" "INSTALL_HEADERS_PREFIX"
  '';

  configurePhase = ''
    runHook preConfigure
    qmake -r PREFIX=$out BUILD_MODE+=lib
    runHook postConfigure
  '';

  meta = with stdenv.lib; {
    version = "0.9.2";
    description = "Telegram API tools for QtQml and Qml";
    homepage = src.meta.homepage;
    license = licenses.gpl3;
    maintainers = [ maintainers.profpatsch ];
    platforms = platforms.linux;
  };

}

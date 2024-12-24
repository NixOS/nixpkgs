{
  lib,
  mkDerivation,
  fetchFromGitHub,
  qmake,
  qtsvg,
  makeWrapper,
  xdg-utils,
}:

mkDerivation rec {
  pname = "mytetra";
  version = "1.44.55";

  src = fetchFromGitHub {
    owner = "xintrea";
    repo = "mytetra_dev";
    rev = "v.${version}";
    sha256 = "sha256-jQXnDoLkqbDZxfsYKPDsTOE7p/BFeA8wEznpbkRVGdw=";
  };

  nativeBuildInputs = [
    qmake
    makeWrapper
  ];
  buildInputs = [ qtsvg ];

  hardeningDisable = [ "format" ];

  preBuild = ''
    substituteInPlace app/app.pro \
      --replace /usr/local/bin $out/bin \
      --replace /usr/share $out/share

    substituteInPlace app/src/views/mainWindow/MainWindow.cpp \
      --replace ":/resource/pic/logo.svg" "$out/share/icons/hicolor/48x48/apps/mytetra.png"

    # https://github.com/xintrea/mytetra_dev/issues/164
    substituteInPlace thirdParty/mimetex/mimetex.c \
      --replace "const char *strcasestr" "char *strcasestr"
  '';

  postFixup = ''
    # make xdg-open overrideable at runtime
    wrapProgram $out/bin/mytetra \
      --suffix PATH : ${xdg-utils}/bin
  '';

  meta = with lib; {
    description = "Smart manager for information collecting";
    mainProgram = "mytetra";
    homepage = "https://webhamster.ru/site/page/index/articles/projectcode/138";
    license = licenses.gpl3;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}

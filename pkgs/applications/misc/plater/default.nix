{
  mkDerivation,
  cmake,
  fetchFromGitHub,
  lib,
  libGLU,
  makeDesktopItem,
  qtbase,
  wrapQtAppsHook,
}:

mkDerivation rec {
  pname = "plater";
  version = "2020-07-30";

  src = fetchFromGitHub {
    owner = "Rhoban";
    repo = "Plater";
    rev = "f8de6d038f95a9edebfcfe142c8e9783697d5b47";
    sha256 = "0r20mbzd16zv1aiadjqdy7z6sp09rr6lgfxhvir4ll3cpakkynr4";
  };

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];
  buildInputs = [
    libGLU
    qtbase
  ];

  desktopItem = makeDesktopItem {
    name = pname;
    exec = pname;
    icon = pname;
    desktopName = "Ideamaker";
    genericName = meta.description;
    categories = [
      "Utility"
      "Engineering"
    ];
  };

  postInstall = ''
    mkdir -p $out/share/pixmaps
    ln -s ${desktopItem}/share/applications $out/share/
    cp $src/gui/img/plater.png $out/share/pixmaps/${pname}.png
  '';

  meta = with lib; {
    description = "3D-printer parts placer and plate generator";
    homepage = "https://github.com/Rhoban/Plater";
    maintainers = with maintainers; [ lovesegfault ];
    platforms = platforms.linux;
    license = licenses.cc-by-nc-30;
  };
}

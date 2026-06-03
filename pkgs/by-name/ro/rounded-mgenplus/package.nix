{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
}:

stdenvNoCC.mkDerivation rec {
  pname = "rounded-mgenplus";
  version = "20150602";

  src = fetchurl {
    url = "https://osdn.jp/downloads/users/8/8598/${pname}-${version}.7z";
    hash = "sha256-7OpnZJc9k5NiOPHAbtJGMQvsMg9j81DCvbfo0f7uJcw=";
  };

  # avoid automatic move to extracted subdir because the 7z archive has files
  # and dirs at the root
  sourceRoot = ".";

  nativeBuildInputs = [
    _7zz
  ];

  installPhase = ''
    runHook preInstall

    install -m 444 -D -t $out/share/fonts/${pname} ${pname}-*.ttf

    runHook postInstall
  '';

  meta = {
    description = "Japanese font based on Rounded M+ and Noto Sans Japanese";
    homepage = "http://jikasei.me/font/rounded-mgenplus/";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ mnacamura ];
  };
}

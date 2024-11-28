{ lib, stdenvNoCC, fetchurl, p7zip }:

stdenvNoCC.mkDerivation rec {
  pname = "rounded-mgenplus";
  version = "20150602";

  src = fetchurl {
    url = "https://osdn.jp/downloads/users/8/8598/${pname}-${version}.7z";
    hash = "sha256-7OpnZJc9k5NiOPHAbtJGMQvsMg9j81DCvbfo0f7uJcw=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ p7zip ];

  installPhase = ''
    runHook preInstall

    install -m 444 -D -t $out/share/fonts/${pname} ${pname}-*.ttf

    runHook postInstall
  '';

  meta = with lib; {
    description = "Japanese font based on Rounded M+ and Noto Sans Japanese";
    homepage = "http://jikasei.me/font/rounded-mgenplus/";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ mnacamura ];
  };
}

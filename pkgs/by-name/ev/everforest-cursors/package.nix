{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "everforest-cursors";
  version = "3212590527";

  src = fetchurl {
    url = "https://github.com/talwat/everforest-cursors/releases/download/${version}/everforest-cursors-variants.tar.bz2";
    hash = "sha256-xXgtN9wbjbrGLUGYymMEGug9xEs9y44mq18yZVdbiuU=";
  };

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons
    cp -r ./everforest-cursors* $out/share/icons
    runHook postInstall
  '';

  meta = with lib; {
    description = "Everforest cursor theme, based on phinger-cursors";
    homepage = "https://github.com/talwat/everforest-cursors";
    license = licenses.cc-by-sa-40;
    platforms = platforms.linux;
    maintainers = with maintainers; [ stelcodes ];
  };
}

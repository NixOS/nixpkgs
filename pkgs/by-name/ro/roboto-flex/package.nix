{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "roboto-flex";
  version = "3.200";

  src = fetchzip {
    url = "https://github.com/googlefonts/roboto-flex/releases/download/${version}/roboto-flex-fonts.zip";
    stripRoot = false;
    hash = "sha256-p8BvE4f6zQLygl49hzYTXXVQFZEJjrlfUvjNW+miar4=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 roboto-flex-fonts/fonts/variable/*.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/googlefonts/roboto-flex";
    description = "Google Roboto Flex family of fonts";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}

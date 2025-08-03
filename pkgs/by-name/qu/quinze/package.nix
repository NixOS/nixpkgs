{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation {
  name = "quinze";
  version = "2018-09-22";

  src = fetchzip {
    url = "https://fontlibrary.org/assets/downloads/quinze/0271bb7be00ea75dcfa06ef7c7f1054e/quinze.zip";
    hash = "sha256-6C6drbAHme38tF2PtY/YFDdHCbR0JURs4F/K+KZqKiQ=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -m444 -Dt $out/share/fonts/truetype *.ttf

    runHook postInstall
  '';

  meta = with lib; {
    description = "Narrow monospaced font, designed to fit a fifteen pixel bitmap";
    homepage = "https://fontlibrary.org/en/font/quinze";
    license = licenses.ofl;
    maintainers = with maintainers; [ phunehehe ];
    platforms = platforms.all;
  };
}

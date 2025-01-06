{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "plemoljp-nf";
  version = "2.0.0";

  src = fetchzip {
    url = "https://github.com/yuru7/PlemolJP/releases/download/v${version}/PlemolJP_NF_v${version}.zip";
    hash = "sha256-+RFUQv/OjHFfYdodcGpnGJQ6r99q2gHKNFynFm4C8Lo=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm444 PlemolJPConsole_NF/*.ttf -t $out/share/fonts/truetype/plemoljp-nf-console
    install -Dm444 PlemolJP35Console_NF/*.ttf -t $out/share/fonts/truetype/plemoljp-nf-35console

    runHook postInstall
  '';

  meta = with lib; {
    description = "Composite font of IBM Plex Mono, IBM Plex Sans JP and nerd-fonts";
    homepage = "https://github.com/yuru7/PlemolJP";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ kachick ];
  };
}

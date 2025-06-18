{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "plemoljp-nf";
  version = "2.0.4";

  src = fetchzip {
    url = "https://github.com/yuru7/PlemolJP/releases/download/v${version}/PlemolJP_NF_v${version}.zip";
    hash = "sha256-6CMeo6YtWbEH/6xDD1yERhlMiCcOafAsQzcHeWQxuo4=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm444 PlemolJPConsole_NF/*.ttf -t $out/share/fonts/truetype/plemoljp-nf-console
    install -Dm444 PlemolJP35Console_NF/*.ttf -t $out/share/fonts/truetype/plemoljp-nf-35console

    runHook postInstall
  '';

  meta = {
    description = "Composite font of IBM Plex Mono, IBM Plex Sans JP and nerd-fonts";
    homepage = "https://github.com/yuru7/PlemolJP";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ kachick ];
  };
}

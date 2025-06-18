{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation {
  pname = "paratype-pt-mono";
  version = "2.005";

  src = fetchzip {
    urls = [
      "https://company.paratype.com/system/attachments/631/original/ptmono.zip"
      "http://rus.paratype.ru/system/attachments/631/original/ptmono.zip"
    ];
    stripRoot = false;
    hash = "sha256-mfDAu/KGelC6wZpUCrUrLVZKo+XiKNBqcpMI8tH2tMw=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/truetype
    install -Dm644 *.txt -t $out/share/doc/paratype

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://www.paratype.ru/public/";
    description = "Open Paratype font";

    license = "Open Paratype license";
    # no commercial distribution of the font on its own
    # must rename on modification
    # http://www.paratype.ru/public/pt_openlicense.asp

    platforms = platforms.all;
    maintainers = with maintainers; [ raskin ];
  };
}

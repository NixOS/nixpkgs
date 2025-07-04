{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rose-pine-cursor";
  version = "1.1.0";

  srcs = [
    (fetchurl {
      url = "https://github.com/rose-pine/cursor/releases/download/v${finalAttrs.version}/BreezeX-RosePine-Linux.tar.xz";
      hash = "sha256-szDVnOjg5GAgn2OKl853K3jZ5rVsz2PIpQ6dlBKJoa8=";
    })
    (fetchurl {
      url = "https://github.com/rose-pine/cursor/releases/download/v${finalAttrs.version}/BreezeX-RosePineDawn-Linux.tar.xz";
      hash = "sha256-hanfwx9ooT1TbmcgCr63KVYwC1OIzTwjmxzi4Zjcrdg=";
    })
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons
    cp -R BreezeX-RosePine-Linux $out/share/icons/
    cp -R BreezeX-RosePineDawn-Linux $out/share/icons/
    runHook postInstall
  '';

  meta = with lib; {
    description = "Soho vibes for Cursors";
    downloadPage = "https://github.com/rose-pine/cursor/releases";
    homepage = "https://rosepinetheme.com/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ aikooo7 ];
  };
})

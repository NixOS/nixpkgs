{ stdenvNoCC
, fetchurl
, lib
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lxgw-wenkai-screen";
  version = "1.330";
  src = fetchurl {
    url = "https://github.com/lxgw/LxgwWenKai-Screen/releases/download/v${finalAttrs.version}/LXGWWenKaiScreen.ttf";
    hash = "sha256-3C6gZmL5Bn6+26TfI2UdCCnGI8Vw4UTFJRc8n6qlP5o=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 $src $out/share/fonts/truetype/LXGWWenKaiScreen.ttf
    runHook postInstall
  '';

  meta = with lib; {
    description = "LXGW WenKai for Screen Reading.";
    homepage = "https://github.com/lxgw/LxgwWenKai-Screen";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ lebensterben ];
  };
})

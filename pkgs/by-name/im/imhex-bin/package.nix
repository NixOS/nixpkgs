{
  stdenvNoCC,
  _7zz,
  fetchurl,
  makeWrapper,
  lib,
  nix-update-script,
}:
let
  arch = if stdenvNoCC.hostPlatform.isAarch64 then "arm64" else "x86_64";
in
stdenvNoCC.mkDerivation rec {
  pname = "imhex-bin";
  version = "1.35.4";

  src = fetchurl {
    url = "https://github.com/WerWolv/ImHex/releases/download/v${version}/imhex-${version}-macOS-${arch}.dmg";
    hash = "sha256-mGnYl/c4j9fbhEj1akxMthS0+c6eL5lyOe1DXtmOdIs=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    _7zz
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,Applications}
    cp -r ImHex.app $out/Applications/
    makeWrapper $out/Applications/ImHex.app/Contents/MacOS/imhex $out/bin/imhex
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Hex Editor for Reverse Engineers, Programmers and people who value their retinas when working at 3 AM";
    homepage = "https://github.com/WerWolv/ImHex";
    mainProgram = "imhex";
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ pcasaretto ];
    platforms = platforms.darwin;
  };
}

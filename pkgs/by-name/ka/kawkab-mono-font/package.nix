{
  lib,
  stdenvNoCC,
  fetchzip,
}:
let
  pname = "kawkab-mono";
  version = "0.501";
  src = fetchzip {
    url = "https://github.com/aiaf/kawkab-mono/releases/download/v${version}/kawkab-mono-${version}.zip";
    hash = "sha256-cDpQGTu3XzLrDtInAZtnCw6BymX7fupbbr7L4bd7kN8=";
  };
in
stdenvNoCC.mkDerivation {
  inherit pname version src;

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = {
    description = "Monospaced Arabic typeface designed for code and text-editing";
    homepage = "https://makkuk.com/kawkab-mono/";
    downloadPage = "https://github.com/aiaf/kawkab-mono";
    changelog = "https://github.com/aiaf/kawkab-mono/releases/tag/v${version}";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ talal ];
  };
}

{
  meta,
  pname,

  fetchurl,
  stdenvNoCC,
  undmg,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit meta pname;
  version = "10.9.0.3";

  src = fetchurl rec {
    name = "QQMusicMac10.9.0Build03.dmg";
    url = "https://c.y.qq.com/cgi-bin/file_redirect.fcg?bid=dldir&file=ecosfile%2Fmusic_clntupate%2Fmac%2Fother%2F${name}&sign=1-24ca0fe76d2237bd78fc3a04a6e8e6d04d48500bea2b11ab4c700df347c2d8b9-68ec66cd";
    hash = "sha256-rgiwqZRKU67Ro9losEllW7IrVw3in9whCmHZl+z7+HU=";
  };

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r QQMusic.app $out/Applications

    runHook postInstall
  '';
})

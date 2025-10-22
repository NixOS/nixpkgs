{
  meta,
  pname,

  fetchurl,
  stdenvNoCC,
  undmg,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit meta pname;
  version = "10.9.5.1";

  src = fetchurl rec {
    name = "QQMusicMac10.9.5Build01.dmg";
    url = "https://web.archive.org/web/20251123072458/https://dldir.y.qq.com/ecosfile/music_clntupate/mac/other/${name}?sign=1763882683-soEnopxjxa9lWaaJ-0-990abb13bf4511950e235ac28082b1bf";
    hash = "sha256-gI4kAWOdI1t/0uSXmxQubVAqpF9mwTIAym6CqFAeaoU=";
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

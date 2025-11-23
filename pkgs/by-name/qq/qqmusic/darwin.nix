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
    url = "https://dldir.y.qq.com/ecosfile/music_clntupate/mac/other/${name}?sign=1762668084-2cTdiF8zrk7ITo9s-0-8d89bf0203c29c938e8ccd4b32cbf87a";
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

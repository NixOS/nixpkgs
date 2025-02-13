{
  stdenvNoCC,
  fetchurl,
  makeBinaryWrapper,
  undmg,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "krunker";
  version = "2.1.3";

  src = fetchurl {
    url = "https://client2.krunker.io/Official%20Krunker.io%20Client-${finalAttrs.version}.dmg";
    hash = "sha512-brvrOPCsXkkrUGcRxsa8bzpFsrY7GF3llt29ZIax6dC0XBsILKXUleESJ5LpurMOgSBsfxNYjZLPJhicIAtuUA==";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    makeBinaryWrapper
    undmg
  ];

  postInstall = ''
    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    makeBinaryWrapper \
      $out/Applications/Official\ Krunker.io\ Client.app/Contents/MacOS/Official\ Krunker.io\ Client \
      $out/bin/krunker
  '';
})

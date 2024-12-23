{
  stdenv,
  fetchurl,
  undmg,
  meta,
  pname,
  version,
  rev,
}:
stdenv.mkDerivation {
  inherit meta pname version;

  src = fetchurl {
    url = "https://releases.lmstudio.ai/darwin/arm64/${version}/${rev}/LM-Studio-${version}-arm64.dmg";
    hash = "sha256-XPaXIWd/Xl3i5dS+5WY9OEIB9PNWe5y9C1MwoZMDht0=";
  };

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -r *.app $out/Applications
    runHook postInstall
  '';
}

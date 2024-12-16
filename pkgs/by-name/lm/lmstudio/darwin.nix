{
  stdenv,
  fetchurl,
  undmg,
  meta,
  pname,
  version,
}:
stdenv.mkDerivation {
  inherit meta pname version;

  src = fetchurl {
    url = "https://releases.lmstudio.ai/darwin/arm64/${version}/3/LM-Studio-${version}-arm64.dmg";
    hash = "sha256-b9QJMZl42D3TL8nzoQ+Dtxhit8uzGp9gByeCCHyu6gw=";
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

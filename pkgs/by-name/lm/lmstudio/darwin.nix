{ stdenv
, fetchurl
, undmg
, meta
, pname
, version
}:
stdenv.mkDerivation {
  inherit meta pname version;

  src = fetchurl {
    url = "https://releases.lmstudio.ai/darwin/arm64/${version}/LM%20Studio-${version}-arm64.dmg";
    hash = "sha256-KC4nXhMkrRDRtLPnpD5UTyKzQ+xH9jhZZHnjk9gDVfo=";
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


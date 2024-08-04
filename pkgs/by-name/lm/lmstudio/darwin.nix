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
    url = "https://files.lmstudio.ai/mac/${version}/latest/LM-Studio-${version}-arm64.dmg";
    hash = "sha256-1AgEk6lDN8Mxe8z7cBbgbTHmLVCbh1Ei+l+FIurbtlM=";
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


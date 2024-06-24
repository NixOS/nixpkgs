{
  stdenvNoCC,
  fetchurl,
  unzip,
  makeWrapper,

  pname,
  version,
  meta,
}:
stdenvNoCC.mkDerivation rec {
  inherit pname version meta;

  src = fetchurl {
    url = "https://github.com/ThaUnknown/miru/releases/download/v${version}/mac-Miru-${version}-mac.zip";
    hash = "sha256-OakGB5Fz1Tlxa/Uu7xHlKoEF9VRfWFQ9CjsR0eCRyQw=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    unzip
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,Applications}
    cp -r Miru.app $out/Applications/
    makeWrapper $out/Applications/Miru.app/Contents/MacOS/Miru $out/bin/miru
    runHook postInstall
  '';
}

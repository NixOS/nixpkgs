{
  stdenvNoCC,
  fetchurl,
  unzip,
  makeWrapper,

  pname,
  version,
  meta,
  passthru,
}:
stdenvNoCC.mkDerivation rec {
  inherit
    pname
    version
    meta
    passthru
    ;

  src = fetchurl {
    url = "https://github.com/ThaUnknown/miru/releases/download/v${version}/mac-Miru-${version}-mac.zip";
    hash = "sha256-V4Vo9fuQ0X7Q6CBM7Akh3+MrgQOBgCuC41khFatYWi4=";
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

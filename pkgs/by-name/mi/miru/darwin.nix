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
    hash = "sha256-4PUi/q9Dtyp6c++hmwfoW5cluzolZYANnKXtiMqlMGo=";
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

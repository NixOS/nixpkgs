{
  pname,
  version,
  src,
  passthru,
  meta,
  stdenvNoCC,
  unzip,
}:
stdenvNoCC.mkDerivation {
  inherit
    pname
    version
    src
    passthru
    meta
    ;

  sourceRoot = ".";
  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -R Fastmail.app $out/Applications/

    runHook postInstall
  '';

  dontBuild = true;

  # Fastmail is notarized
  dontFixup = true;
}

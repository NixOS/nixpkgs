{
  stdenvNoCC,
  meta,
  passthru,
  pname,
  src,
  version,
  unzip,
}:
stdenvNoCC.mkDerivation {
  inherit
    meta
    passthru
    pname
    src
    version
    ;

  sourceRoot = ".";
  nativeBuildInputs = [ unzip ];
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -R "Beeper Desktop.app" $out/Applications/
    runHook postInstall
  '';
}

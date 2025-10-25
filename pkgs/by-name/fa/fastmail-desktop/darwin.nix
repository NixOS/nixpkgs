{
  pname,
  version,
  src,
  passthru,
  meta,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  inherit
    pname
    version
    src
    passthru
    meta
    ;

  installPhase = ''
    mkdir -p $out/Applications
    cp -R Fastmail.app $out/Applications/
  '';

  dontBuild = true;

  # Fastmail is notarized
  dontFixup = true;
}

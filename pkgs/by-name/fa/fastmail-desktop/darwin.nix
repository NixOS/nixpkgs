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
    mkdir -p $out/Applications
    cp -R Fastmail.app $out/Applications/
  '';

  dontBuild = true;

  # Fastmail is notarized
  dontFixup = true;
}

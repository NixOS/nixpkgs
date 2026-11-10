{
  pname,
  version,
  src,
  passthru,
  meta,

  stdenvNoCC,
  undmg,
}:
stdenvNoCC.mkDerivation {
  inherit
    pname
    version
    src
    passthru
    meta
    ;

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -a Slack.app $out/Applications
    runHook postInstall
  '';
}

{
  stdenv,
  undmg,
  pname,
  version,
  passthru,
  meta,
}:

stdenv.mkDerivation (finalAttrs: {
  inherit
    pname
    version
    passthru
    meta
    ;

  src = passthru.sources.${stdenv.hostPlatform.system};

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    runHook postInstall
  '';
})

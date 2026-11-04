{
  stdenv,
  undmg,

  pname,
  passthru,
  meta,
  ...
}:

stdenv.mkDerivation (finalAttrs: {
  inherit pname;
  inherit (finalAttrs.passthru.source) version;
  inherit (finalAttrs.passthru) src;

  nativeBuildInputs = [ undmg ];
  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -a QQ.app $out/Applications

    runHook postInstall
  '';

  passthru = passthru finalAttrs;
  meta = meta finalAttrs;
})

{
  stdenv,
  _7zz,

  pname,
  passthru,
  meta,
  ...
}:

stdenv.mkDerivation (finalAttrs: {
  inherit pname;
  inherit (finalAttrs.passthru.source) version;
  inherit (finalAttrs.passthru) src;

  # _7zz uses "-sns-" to avoid invalidating the code signature.
  nativeBuildInputs = [ _7zz ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -a QQ.app $out/Applications

    runHook postInstall
  '';

  dontStrip = true;

  passthru = passthru finalAttrs;
  meta = meta finalAttrs;
})

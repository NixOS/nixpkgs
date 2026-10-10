{
  lib,
  stdenv,
  fetchFromSourcehut,
  fennel,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fnlfmt";
  version = "0.3.2";

  src = fetchFromSourcehut {
    owner = "~technomancy";
    repo = "fnlfmt";
    tag = finalAttrs.version;
    hash = "sha256-wbeWAv4xhxh7M6tRd9qpgBRtg1/fqg0AUPvh2M5f60Q=";
  };

  buildInputs = [ fennel ];

  makeFlags = [
    "PREFIX=$(out)"
    "FENNEL=${fennel}/bin/fennel"
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/fnlfmt --help > /dev/null

    runHook postInstallCheck
  '';

  meta = {
    description = "Formatter for Fennel";
    homepage = finalAttrs.src.meta.homepage;
    changelog = "${finalAttrs.src.meta.homepage}/tree/${finalAttrs.version}/changelog.md";
    license = lib.licenses.mit;
    platforms = fennel.meta.platforms;
    maintainers = with lib.maintainers; [ chiroptical ];
    mainProgram = "fnlfmt";
  };
})

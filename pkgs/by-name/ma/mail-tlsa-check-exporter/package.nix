{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  makeWrapper,
  nodejs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mail-tlsa-check-exporter";
  version = "0-unstable-2025-06-12";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "ietf-tools";
    repo = "mail-tlsa-check-exporter";
    rev = "9843bf85971fbe130e8cd32e6fcf0dfcee92e929";
    hash = "sha256-5c3epExz3tv6gRiIfpDyV1pkfcRVWjtNpl93LWsYKdk=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/libexec
    cp $src/index.mjs $out/libexec

    makeWrapper ${lib.getExe nodejs} $out/bin/mail-tlsa-check-exporter \
      --append-flag $out/libexec/index.mjs

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch=main" ];
  };

  meta = {
    description = "Validate SMTP / IMAP server certificates against a TLSA record as a Prometheus exporter";
    homepage = "https://github.com/ietf-tools/mail-tlsa-check-exporter";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bartoostveen ];
    mainProgram = "mail-tlsa-check-exporter";
    platforms = lib.platforms.all;
  };
})

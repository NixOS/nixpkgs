{
  lib,
  rustPlatform,
  fetchCrate,
  fetchurl,
  cacert,
  gitMinimal,
  jq,
  sops,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "secretspec";
  version = "0.20.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-UuXCDQ/DiC1xDs63+kbJNC01ZQfsh2j5/qRP76MVle8=";
  };

  cargoHash = "sha256-41UxtnzpDMYpWshpopXLIXyz6rzikJkqKbvxHVua1oo=";

  postPatch = ''
    mkdir -p ../tests/fixtures
    cp ${
      fetchurl {
        url = "https://raw.githubusercontent.com/cachix/secretspec/v${finalAttrs.version}/tests/fixtures/bw-shim.sh";
        hash = "sha256-wHXeJk3KYu01J73BEdll9lCcjOD4+8g8rlWUw93Cyok=";
      }
    } ../tests/fixtures/bw-shim.sh
    chmod +x ../tests/fixtures/bw-shim.sh
    patchShebangs ../tests/fixtures/bw-shim.sh
  '';

  nativeCheckInputs = [
    gitMinimal
    jq
    sops
  ];

  preCheck = ''
    export HOME="$TMPDIR"
    export NO_COLOR=1
    export SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt"
  '';

  # A test binds to localhost, which requires an explicit Darwin sandbox exception.
  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Declarative secrets, every environment, any provider";
    homepage = "https://secretspec.dev";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      domenkozar
      sandydoo
    ];
    mainProgram = "secretspec";
  };
})

{
  lib,
  rustPlatform,
  fetchCrate,
  fetchurl,
  cacert,
  jq,
  sops,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "secretspec";
  version = "0.18.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-4N567/oDMgV81zlusn7TFQcDyWATvpoq879ZL/pzbuU=";
  };

  cargoHash = "sha256-oMoRoKXjaCOER2KvKnLmSh9nKeYErh54IlQPFLHW8sE=";

  postPatch = ''
    mkdir -p ../tests/fixtures
    cp ${
      fetchurl {
        url = "https://raw.githubusercontent.com/cachix/secretspec/v${finalAttrs.version}/tests/fixtures/bw-shim.sh";
        hash = "sha256-Xg1d8h2DOA6p0Hn9xP9TYzFN1863Wyk3QuQlFk+Y0ME=";
      }
    } ../tests/fixtures/bw-shim.sh
    chmod +x ../tests/fixtures/bw-shim.sh
    patchShebangs ../tests/fixtures/bw-shim.sh
  '';

  nativeCheckInputs = [
    jq
    sops
  ];

  preCheck = ''
    export HOME="$TMPDIR"
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

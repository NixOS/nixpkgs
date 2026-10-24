{
  lib,
  rustPlatform,
  fetchCrate,
  cacert,
  gitMinimal,
  jq,
  sops,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "secretspec";
  version = "0.21.1";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-VCvo+O3IHVUeZG6cxBmWy8/CEDZOwVr8IVcWxroUd00=";
  };

  cargoHash = "sha256-cA7HmOxCrfPiBKI8xxxpRBvGLUgyl4Ts1uhoCt0bBuk=";

  postPatch = ''
    patchShebangs tests/fixtures/bw-shim.sh
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

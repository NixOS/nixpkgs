{
  lib,
  rustPlatform,
  fetchCrate,
  fetchFromGitHub,
  cacert,
  gitMinimal,
  jq,
  sops,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "secretspec";
  version = "0.21.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-U7cSQbkOsmTfJynb1YizyZI2STpX7fz9N8JmJDHNr9w=";
  };

  cargoHash = "sha256-rPtPWBq7MK/e9J4IHRpXlFtSwFom14QIgWXBEwJc/bI=";

  # The tests read fixtures from the repository that are not part of the
  # published crate.
  postPatch = ''
    cp -r --no-preserve=mode ${
      fetchFromGitHub {
        owner = "cachix";
        repo = "secretspec";
        tag = "v${finalAttrs.version}";
        sparseCheckout = [
          "conformance/ipc/cases"
          "docs/public/schema"
          "tests/fixtures"
        ];
        hash = "sha256-nSX5ctVUuTIqgunQ8RRCJi26bS19ohj5HNedXc8rfE0=";
      }
    }/{conformance,docs,tests} ..
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

  checkFlags = [
    # These walk every ancestor of the temporary directory and require root or
    # user ownership; the sandbox root is owned by the overflow uid.
    "--skip=provider::external::tests::a_sticky_world_writable_ancestor_is_accepted"
    "--skip=provider::external::tests::a_symlinked_component_is_validated_through_to_its_target"
    "--skip=provider::external::tests::a_writable_ancestor_above_a_tight_parent_is_rejected"
    "--skip=provider::external::tests::platform_policy_accepts_owner_only_files_and_rejects_writable_registration"
  ];

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

{
  lib,
  fetchFromGitHub,
  rustPlatform,
  cacert,
  cmake,
  gitMinimal,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "aube";
  version = "1.32.0";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "aube";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0BnaxRk6+KY4AGZ31lis0zxc9uWp3OrxCgp9SgOrqNI=";
  };

  cargoHash = "sha256-vYbbnEpVWG6kjnycl1kk3D+lXuzTzOKuilA0ImBHYAI=";

  nativeBuildInputs = [ cmake ]; # libz-ng-sys

  nativeCheckInputs = [
    gitMinimal
    writableTmpDirAsHomeHook
  ];

  postInstall = ''
    rm -f $out/bin/generate-{error-codes,settings}-docs
  '';

  checkFlags = [
    # failed on x86_64-linux
    "--skip=concurrency::tests::floor_and_ceiling_inclusive"
    "--skip=http::ticket_cache::tests::max_per_host_evicts_oldest"
    "--skip=http::ticket_cache::tests::invalidate_removes_all_for_host"
    # require network access
    "--skip=http::ticket_cache::tests::roundtrip_persists_across_open"
  ];

  __darwinAllowLocalNetworking = true;

  env.SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Fast Node.js package manager";
    homepage = "https://github.com/jdx/aube";
    changelog = "https://github.com/jdx/aube/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      chillcicada
      Br1ght0ne
    ];
    mainProgram = "aube";
  };
})

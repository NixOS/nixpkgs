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
  version = "1.29.1";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "aube";
    tag = "v${finalAttrs.version}";
    hash = "sha256-87r9qltKUhjnYG9O484OUzKFiO8Xoge9VZ13l6RgrdA=";
  };

  cargoHash = "sha256-Cy5Ea/rF2IJ5WppKKI7E1toy9N+bQEArVW9o2pHzBMc=";

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

{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  buildPackages,
  makeBinaryWrapper,
  fetchpatch2,
  installShellFiles,
  pkg-config,
  zstd,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dprint";
  version = "0.61.1";
  __structuredAttrs = true;

  # Prefer repository rather than crate here
  #   - They have Cargo.lock in the repository
  #   - They have WASM files in the repository which will be used in checkPhase
  src = fetchFromGitHub {
    owner = "dprint";
    repo = "dprint";
    tag = finalAttrs.version;
    hash = "sha256-MEcz5dmCp7pzxJOlU/2+1+60KB2XkFN7dtBMZaEpvVk=";
  };

  cargoPatches = [
    # Because of a rustc version mismatch between dprint-0.64.1 and release-26.05, we can only cherry-pick the webpki-roots update to fix #576544
    (fetchpatch2 {
      url = "https://github.com/dprint/dprint/commit/9c6121aa33ef760ef92f10d31a32cfe878932f5d.patch?full_index=1";
      hash = "sha256-mYzJj+BlCOwuDMGmj5bio0UrrUH86tS6/3Pfn7EgUNk=";
    })
  ];

  cargoHash = "sha256-9Wl2tjExyxjDpwcDhr5SOrn2+7n4jKqwsNirKYA1Z/g=";

  nativeBuildInputs = [
    makeBinaryWrapper
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    zstd
  ];

  env = {
    # Avoiding "Undefined symbols" such as "___unw_remove_find_dynamic_unwind_sections" since dprint 0.50.1
    # Adding "libunwind" in buildInputs did not resolve it.
    RUSTFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-C link-args=-Wl,-undefined,dynamic_lookup";
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  # Avoiding utils::url::test::* failures in the Darwin sandbox
  __darwinAllowLocalNetworking = true;

  cargoBuildFlags = [
    "--package=dprint"
    # Required only for dprint package tests; the binary is removed in postInstall.
    "--package=test-process-plugin"
  ];

  cargoTestFlags = [
    "--package=dprint"
  ];

  checkFlags = [
    # Require cargo is running
    "--skip=utils::process::test"
  ];

  postInstall =
    let
      dprint =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          "$out/bin/dprint"
        else
          lib.getExe buildPackages.dprint;
    in
    # dprint only supports a runtime switch (DPRINT_TLS_CA_STORE) to prefer system certs.
    # Avoid the upstream default `mozilla,system` to reduce risks like https://github.com/NixOS/nixpkgs/issues/576485
    ''
      rm "$out/bin/test-process-plugin"
      wrapProgram "$out/bin/dprint" \
        --set-default DPRINT_TLS_CA_STORE system
      export DPRINT_CACHE_DIR="$(mktemp -d)"
      installShellCompletion --cmd dprint \
        --bash <(${dprint} completions bash) \
        --zsh <(${dprint} completions zsh) \
        --fish <(${dprint} completions fish)
    '';

  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/dprint";
  versionCheckKeepEnvironment = [ "HOME" ];

  passthru = {
    updateScript = nix-update-script {
      # Follow upstream's release policy. Git tags are not enough for this package:
      # https://github.com/dprint/dprint/issues/1113
      extraArgs = [ "--use-github-releases" ];
    };
  };

  meta = {
    description = "Code formatting platform written in Rust";
    longDescription = ''
      dprint is a pluggable and configurable code formatting platform written in Rust.
      It offers multiple WASM plugins to support various languages. It's written in
      Rust, so it’s small, fast, and portable.
    '';
    changelog = "https://github.com/dprint/dprint/releases/tag/${finalAttrs.version}";
    homepage = "https://dprint.dev";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kachick
      phanirithvij
    ];
    mainProgram = "dprint";
  };
})

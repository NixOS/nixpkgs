{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  alsa-lib,
  stdenv,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pigma";
  version = "0.3.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "akirco";
    repo = "pigma";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-uR6U85S11XnTojy1ZEdqc7bhmFNp6ac3028o0JuX5uU=";
  };

  cargoHash = "sha256-hwESsiv+qdpAbyvMsW1cZ3XeYJPj7CF86Tb9z2q8ng4=";

  patches = [
    # The upstream test creates a reqwest client without installing a Rustls provider.
    ./test-rustls-provider.patch
  ];

  postPatch = ''
    # Use the linker selected by stdenv instead of upstream's lld override.
    rm .cargo/config.toml

    # The binary and examples inherit dependencies used only by the library.
    substituteInPlace Cargo.toml \
      --replace-fail 'unused_crate_dependencies = "deny"' 'unused_crate_dependencies = "allow"'
  '';

  nativeBuildInputs = [ installShellFiles ] ++ lib.optional stdenv.hostPlatform.isLinux pkg-config;

  buildInputs = lib.optional stdenv.hostPlatform.isLinux alsa-lib;

  cargoTestFlags = [ "--workspace" ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd pigma \
      --bash <($out/bin/pigma completions bash) \
      --fish <($out/bin/pigma completions fish) \
      --zsh <($out/bin/pigma completions zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal client for NetEase Cloud Music and local audio playback";
    homepage = "https://github.com/akirco/pigma";
    changelog = "https://github.com/akirco/pigma/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ NikoPit ];
    mainProgram = "pigma";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})

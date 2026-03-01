{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  nix-update-script,
  tzdata,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustic";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "rustic-rs";
    repo = "rustic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2xSQ+nbP7/GsIWvj9sgG+jgIIIesfEW8T9z5Tijd90E=";
  };

  cargoHash = "sha256-4yiWIlibYldr3qny0KRRIHBqHCx6R9gDiiheGkJrwEY=";

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [ tzdata ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd rustic \
      --bash <($out/bin/rustic completions bash) \
      --fish <($out/bin/rustic completions fish) \
      --zsh <($out/bin/rustic completions zsh)
  '';

  # We set TZDIR to avoid this warning during unit tests:
  # > [WARN] could not find zoneinfo, concatenated tzdata or bundled time zone database
  # This warning causes the check phase to fail.
  preCheck = ''
    export TZDIR=${tzdata}/share/zoneinfo
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/rustic-rs/rustic";
    changelog = "https://github.com/rustic-rs/rustic/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "Fast, encrypted, deduplicated backups powered by pure Rust";
    mainProgram = "rustic";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = [
      lib.licenses.mit
      lib.licenses.asl20
    ];
    maintainers = [
      lib.maintainers.nobbz
      lib.maintainers.pmw
    ];
  };
})

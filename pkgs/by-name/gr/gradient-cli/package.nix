{
  lib,
  gradient,
  installShellFiles,
  libgit2,
  openssl,
  pkg-config,
  rustPlatform,
  stdenv,
  zlib,
  zstd,
  withEval ? false,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gradient-cli";
  inherit (gradient) version src;
  __structuredAttrs = true;

  sourceRoot = "${finalAttrs.src.name}/cli";

  cargoHash = "sha256-Q0sUI1uQ0zmra9s6u1lRFgDNaF9w+6Es2fQffMvh6+A=";

  buildFeatures = [ "nix" ] ++ lib.optional withEval "eval";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ]
  ++ lib.optional withEval rustPlatform.bindgenHook;

  buildInputs = [
    libgit2
    openssl
    zlib
    zstd
  ]
  ++ lib.optional withEval gradient.nix;

  env = {
    LIBGIT2_NO_VENDOR = 1;
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  # The builder's stdout is a terminal, so plain output gets colored.
  checkFlags = [ "--skip=output::tests::a_piped_run_stays_plain" ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd gradient \
      --bash <($out/bin/gradient completion bash) \
      --fish <($out/bin/gradient completion fish) \
      --zsh <($out/bin/gradient completion zsh)
  '';

  meta = {
    description = "Nix-CI for Teams (command line client)";
    inherit (gradient.meta)
      homepage
      changelog
      license
      maintainers
      ;
    mainProgram = "gradient";
  };
})

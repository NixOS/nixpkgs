{
  lib,
  gradient,
  gradient-nix,
  installShellFiles,
  openssl,
  pkg-config,
  rustPlatform,
  stdenv,
  withEval ? false,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gradient-cli";
  inherit (gradient) version src;
  __structuredAttrs = true;

  sourceRoot = "${finalAttrs.src.name}/cli";

  cargoHash = "sha256-+SzQ1/KM+o7lrWNxtutRuCkSHORHD+xASXYrhgGUWVo=";

  buildFeatures = [ "nix" ] ++ lib.optional withEval "eval";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ]
  ++ lib.optional withEval rustPlatform.bindgenHook;

  buildInputs = [ openssl ] ++ lib.optional withEval gradient-nix;

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
      teams
      ;
    mainProgram = "gradient";
  };
})

{
  aws-lc,
  buildFeatures ? [ ],
  buildNoDefaultFeatures ? false,
  buildPackages,
  fetchFromGitHub,
  installManPages ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  installShellCompletions ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  installShellFiles,
  lib,
  openssl,
  pkg-config,
  rustPlatform,
  stdenv,
}:

let
  nativeTls = builtins.elem "native-tls" buildFeatures;
  rustlsAws = builtins.elem "rustls-aws" buildFeatures;
in
rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  inherit buildNoDefaultFeatures;

  pname = "ortie";
  version = "3.0.0";
  cargoHash = "sha256-AOKGfH+oCe62cjZhfwr0F2AXRZFq9xrX9OqsZUOB2Cc=";

  src = fetchFromGitHub {
    owner = "pimalaya";
    repo = "ortie";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AX13jg8wVlDNABDe8IcdCEOEdoNm6Twr2HZ/CHaqOdI=";
  };

  env = {
    # openssl should not be provided by vendors, not even on windows
    OPENSSL_NO_VENDOR = 1;
  };

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = lib.optional nativeTls openssl ++ lib.optional rustlsAws aws-lc;

  inherit buildFeatures;

  postInstall =
    let
      exe =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          "$out/bin/ortie"
        else
          lib.getExe buildPackages.ortie;
    in
    ''
      mkdir -p $out/share/{completions,man,schemas}
      install -Dm644 config.sample.toml "$out"/share/doc/ortie/config.sample.toml
      ${exe} manual -d "$out"/share/man
      ${exe} completion -d "$out"/share/completions bash elvish fish powershell zsh
      ${exe} json-schema -d "$out"/share/schemas
    ''
    + lib.optionalString installManPages ''
      installManPage "$out"/share/man/*
    ''
    + lib.optionalString installShellCompletions ''
      installShellCompletion --cmd ortie \
        --bash "$out"/share/completions/ortie.bash \
        --fish "$out"/share/completions/ortie.fish \
        --zsh "$out"/share/completions/_ortie
    '';

  # disable impure integration tests: they bind sockets and spawn processes
  cargoTestFlags = [ "--bins" ];

  # two unit tests of 3.0.0 bind a loopback socket
  __darwinAllowLocalNetworking = true;

  meta = {
    description = "CLI to manage OAuth tokens";
    mainProgram = "ortie";
    homepage = "https://github.com/pimalaya/ortie";
    changelog = "https://github.com/pimalaya/ortie/releases/tag/${finalAttrs.src.tag}";
    license =
      with lib.licenses;
      OR [
        asl20
        mit
      ];
    maintainers = with lib.maintainers; [
      soywod
      bobberb
    ];
  };
})

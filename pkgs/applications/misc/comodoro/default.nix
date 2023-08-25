{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, installShellFiles
, installShellCompletions ? stdenv.hostPlatform == stdenv.buildPlatform
, installManPages ? stdenv.hostPlatform == stdenv.buildPlatform
, withTcp ? true
}:

rustPlatform.buildRustPackage rec {
  pname = "comodoro";
  version = "0.0.9";

  src = fetchFromGitHub {
    owner = "soywod";
    repo = "comodoro";
    rev = "v${version}";
    hash = "sha256-pxe3Nv1N85uWsiv4s0wtD++zlZZgMADH51f5RMK9huA=";
  };

  cargoSha256 = "E5oHeMow9MrVrlDX+v0tX9Nv3gHUxDNUpRAT5jPa+DI=";

  nativeBuildInputs = lib.optional (installManPages || installShellCompletions) installShellFiles;

  buildNoDefaultFeatures = true;
  buildFeatures = lib.optional withTcp "tcp";

  postInstall = lib.optionalString installManPages ''
    mkdir -p $out/man
    $out/bin/comodoro man $out/man
    installManPage $out/man/*
  '' + lib.optionalString installShellCompletions ''
    installShellCompletion --cmd comodoro \
      --bash <($out/bin/comodoro completion bash) \
      --fish <($out/bin/comodoro completion fish) \
      --zsh <($out/bin/comodoro completion zsh)
  '';

  meta = with lib; {
    description = "CLI to manage your time.";
    homepage = "https://pimalaya.org/comodoro/";
    changelog = "https://github.com/soywod/comodoro/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ soywod ];
  };
}

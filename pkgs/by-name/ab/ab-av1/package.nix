{ lib, rustPlatform, fetchFromGitHub, installShellFiles, stdenv }:

rustPlatform.buildRustPackage rec {
  pname = "ab-av1";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "alexheretic";
    repo = "ab-av1";
    rev = "v${version}";
    hash = "sha256-xKZVvwRSCd4AxJnfEnRYuyB0yhxkg19a2tI0x2rcvWs=";
  };

  cargoHash = "sha256-nK3ye3wJBBv4ei41e9V/bj5kg5ujjzi0EvLwKKfvfUU=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ab-av1 \
      --bash <($out/bin/ab-av1 print-completions bash) \
      --fish <($out/bin/ab-av1 print-completions fish) \
      --zsh <($out/bin/ab-av1 print-completions zsh)
  '';

  meta = with lib; {
    description = "AV1 re-encoding using ffmpeg, svt-av1 & vmaf";
    homepage = "https://github.com/alexheretic/ab-av1";
    changelog = "https://github.com/alexheretic/ab-av1/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "ab-av1";
  };
}

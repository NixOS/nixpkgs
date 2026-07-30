{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ab-av1";
  version = "0.11.4";

  src = fetchFromGitHub {
    owner = "alexheretic";
    repo = "ab-av1";
    tag = "v${finalAttrs.version}";
    hash = "sha256-830STu0YfEhsYr4EU3ATF6kgH5J/tUEhm4b47VOwMEQ=";
  };

  cargoHash = "sha256-mKtP+QoG0MjbBB4kMLlioyxshlgVyhqLH4C5GKx9Hes=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ab-av1 \
      --bash <($out/bin/ab-av1 print-completions bash) \
      --fish <($out/bin/ab-av1 print-completions fish) \
      --zsh <($out/bin/ab-av1 print-completions zsh)
  '';

  meta = {
    description = "AV1 re-encoding using ffmpeg, svt-av1 & vmaf";
    homepage = "https://github.com/alexheretic/ab-av1";
    changelog = "https://github.com/alexheretic/ab-av1/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "ab-av1";
  };
})

{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  makeWrapper,
  fzf,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "git-smash";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "anthraxx";
    repo = "git-smash";
    rev = "refs/tags/v${version}";
    hash = "sha256-NyNYEF5g0O9xNhq+CoDPhQXZ+ISiY4DsShpjk5nP0N8=";
  };

  cargoHash = "sha256-omITZMBWzYlHHim/IXNa1rtiwHqpgLJ5G9z15YvDRi0=";

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  postFixup = ''
    wrapProgram "$out/bin/git-smash" --suffix PATH : "${lib.makeBinPath [ fzf ]}"
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd git-smash \
      --bash <($out/bin/git-smash completions bash) \
      --fish <($out/bin/git-smash completions fish) \
      --zsh <($out/bin/git-smash completions zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Smash staged changes into previous commits to support your Git workflow, pull request and feature branch maintenance";
    homepage = "https://github.com/anthraxx/git-smash";
    changelog = "https://github.com/anthraxx/git-smash/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "git-smash";
    maintainers = with lib.maintainers; [ bcyran ];
  };
}

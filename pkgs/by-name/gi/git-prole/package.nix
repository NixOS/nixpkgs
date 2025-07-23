{
  lib,
  stdenv,
  buildPackages,
  fetchFromGitHub,
  rustPlatform,
  git,
  nix-update-script,
  installShellFiles,
}:
let
  version = "0.5.3";
in
rustPlatform.buildRustPackage {
  pname = "git-prole";
  inherit version;

  src = fetchFromGitHub {
    owner = "9999years";
    repo = "git-prole";
    tag = "v${version}";
    hash = "sha256-QwLkByC8gdAnt6geZS285ErdH8nfV3vsWjMF4hTzq9Y=";
  };

  buildFeatures = [ "clap_mangen" ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-qghc8HtJfpTYXAwC2xjq8lLlCu419Ttnu/AYapkAulI=";

  nativeCheckInputs = [
    git
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall =
    let
      exe =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          "$out/bin/git-prole"
        else
          lib.getExe buildPackages.git-prole;
    in
    ''
      manpages=$(mktemp -d)
      ${exe} manpages "$manpages"
      for manpage in "$manpages"/*; do
        installManPage "$manpage"
      done

      installShellCompletion --cmd git-prole \
        --bash <(${exe} completions bash) \
        --fish <(${exe} completions fish) \
        --zsh <(${exe} completions zsh)
    '';

  meta = {
    homepage = "https://github.com/9999years/git-prole";
    changelog = "https://github.com/9999years/git-prole/releases/tag/v${version}";
    description = "`git-worktree(1)` manager";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers._9999years ];
    mainProgram = "git-prole";
  };

  passthru.updateScript = nix-update-script { };
}

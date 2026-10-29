{
  lib,
  buildGoModule,
  installShellFiles,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "exercism";
  version = "3.5.9";

  src = fetchFromGitHub {
    owner = "exercism";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sXKE9FpiziRz1O5mMGhdXwqUxKwo082C7PImSorDNjA=";
  };

  vendorHash = "sha256-XkntjTcfESKB8La/GuWRUZoB9FIcawqrVxSZQ8SYbKA=";

  doCheck = false;

  subPackages = [ "./exercism" ];

  nativeBuildInputs = [ installShellFiles ];

  passthru.updateScript = nix-update-script { };

  postInstall = ''
    installShellCompletion --cmd exercism \
      --bash shell/exercism_completion.bash \
      --fish shell/exercism.fish \
      --zsh shell/exercism_completion.zsh
  '';

  meta = {
    inherit (finalAttrs.src.meta) homepage;
    description = "Go based command line tool for exercism.io";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.rbasso
      lib.maintainers.nobbz
    ];
    mainProgram = "exercism";
  };
})

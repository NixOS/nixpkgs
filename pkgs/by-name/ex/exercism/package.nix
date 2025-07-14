{
  lib,
  buildGoModule,
  installShellFiles,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "exercism";
  version = "3.5.6";

  src = fetchFromGitHub {
    owner = "exercism";
    repo = "cli";
    tag = "v${version}";
    hash = "sha256-5RUoGrR86dary5k2bMx/G3HKIDccdr/D0UVgDB/soms=";
  };

  vendorHash = "sha256-xY3C3emqtPIKyxIN9aEkrLXhTxWNmo0EJXNZVtbtIvs=";

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

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Go based command line tool for exercism.io";
    license = licenses.mit;
    maintainers = [
      maintainers.rbasso
      maintainers.nobbz
    ];
    mainProgram = "exercism";
  };
}

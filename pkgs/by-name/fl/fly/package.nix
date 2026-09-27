{
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  lib,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "fly";
  version = "8.3.0";

  src = fetchFromGitHub {
    owner = "concourse";
    repo = "concourse";
    rev = "v${finalAttrs.version}";
    hash = "sha256-T52GjR43fvC3BJDFLhYGtALSh8V5o1mAdfIEuIUszrc=";
  };

  vendorHash = "sha256-J+e/UCLK5sdwLEj/AjqEQVD7FZghYxl6Ny65osbDnRg=";

  subPackages = [ "fly" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/concourse/concourse.Version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  doCheck = false;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd fly \
      --bash <($out/bin/fly completion --shell bash) \
      --fish <($out/bin/fly completion --shell fish) \
      --zsh <($out/bin/fly completion --shell zsh)
  '';

  meta = {
    description = "Command line interface to Concourse CI";
    mainProgram = "fly";
    homepage = "https://concourse-ci.org";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      ivanbrennan
      SuperSandro2000
    ];
  };
})

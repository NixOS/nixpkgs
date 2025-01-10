{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:
buildGoModule rec {
  pname = "mangal";
  version = "4.0.6";

  src = fetchFromGitHub {
    owner = "metafates";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-nbJdePlzZFM2ihbvFIMKyYZ9C0uKjU3TE5VLduLvtKE=";
  };

  proxyVendor = true;
  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    # Mangal creates a config file in the folder ~/.config/mangal and fails if not possible
    export HOME=$(mktemp -d)
    installShellCompletion --cmd mangal \
      --bash <($out/bin/mangal completion bash) \
      --zsh <($out/bin/mangal completion zsh) \
      --fish <($out/bin/mangal completion fish)
  '';

  doCheck = false; # test fail because of sandbox

  meta = with lib; {
    description = "CLI app written in Go which scrapes, downloads and packs manga into different formats";
    homepage = "https://github.com/metafates/mangal";
    license = licenses.mit;
    maintainers = [ maintainers.bertof ];
    mainProgram = "mangal";
  };
}

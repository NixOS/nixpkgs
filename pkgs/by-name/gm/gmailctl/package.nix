{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "gmailctl";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "mbrt";
    repo = "gmailctl";
    rev = "v${version}";
    hash = "sha256-euYl7GKidkOFsSxrEnSBIdBNZOKuBBaS3LNQOZy9R9g=";
  };

  vendorHash = "sha256-OXz6GlpC9yhe4pRuVxTUUruJyxBQ63JC4a8xwtuDM/o=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd gmailctl \
      --bash <($out/bin/gmailctl completion bash) \
      --fish <($out/bin/gmailctl completion fish) \
      --zsh <($out/bin/gmailctl completion zsh)
  '';

  doCheck = false;

  meta = with lib; {
    description = "Declarative configuration for Gmail filters";
    homepage = "https://github.com/mbrt/gmailctl";
    license = licenses.mit;
    maintainers = with maintainers; [
      doronbehar
      SuperSandro2000
    ];
  };
}

{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "cirrus-cli";
  version = "0.164.2";

  src = fetchFromGitHub {
    owner = "cirruslabs";
    repo = "cirrus-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/xOiqa26Zfv1AugH3w9euQHmEwLm5S+sSu7DVZDHOzc=";
  };

  vendorHash = "sha256-G/UlmNDzYuF9gkAaGO6O/SziNZ9obs01sD2Cmu+r8Dc=";

  ldflags = [
    "-X github.com/cirruslabs/cirrus-cli/internal/version.Version=v${finalAttrs.version}"
    "-X github.com/cirruslabs/cirrus-cli/internal/version.Commit=v${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd cirrus \
      --bash <($out/bin/cirrus completion bash) \
      --zsh <($out/bin/cirrus completion zsh) \
      --fish <($out/bin/cirrus completion fish)
  '';

  # tests fail on read-only filesystem
  doCheck = false;

  meta = {
    description = "CLI for executing Cirrus tasks locally and in any CI";
    homepage = "https://github.com/cirruslabs/cirrus-cli";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ techknowlogick ];
    mainProgram = "cirrus";
  };
})

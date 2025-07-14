{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  installShellFiles,
}:
buildGoModule (finalAttrs: {
  pname = "gibo";
  version = "3.0.14";

  src = fetchFromGitHub {
    owner = "simonwhitaker";
    repo = "gibo";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-6w+qhwOHkfKt0hgKO98L6Si0RNJN+CXOOFzGlvxFjcA=";
  };

  vendorHash = "sha256-pD+7yvBydg1+BQFP0G8rRYTCO//Wg/6pzY19DLs42Gk=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/simonwhitaker/gibo/cmd.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion --cmd gibo \
      --bash <($out/bin/gibo completion bash) \
      --fish <($out/bin/gibo completion fish) \
      --zsh <($out/bin/gibo completion zsh)
  '';

  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/gibo version | grep -F "${finalAttrs.version}"
    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/simonwhitaker/gibo";
    license = lib.licenses.unlicense;
    description = "Shell script for easily accessing gitignore boilerplates";
    platforms = lib.platforms.unix;
    mainProgram = "gibo";
  };
})

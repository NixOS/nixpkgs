{
  stdenv,
  lib,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
  testers,
  kubelogin,
}:

buildGoModule (finalAttrs: {
  pname = "kubelogin";
  version = "0.2.21";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "kubelogin";
    rev = "v${finalAttrs.version}";
    hash = "sha256-sZMFx8rv3SFEqfETtLm6WCVeGN4ia41egJwXLC8e/fI=";
  };

  patches = [
    ./disable-nix-incompatible-test.patch
  ];

  vendorHash = "sha256-S5seDNIrtjt+MOJ2C8tVCEWy7FpDP8qjb9MTFMrkEJ0=";

  # hack/changelog-generator is a separate Go module since 0.2.15
  subPackages = [ "." ];

  ldflags = [
    "-X main.gitTag=v${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    $out/bin/kubelogin completion bash >kubelogin.bash
    $out/bin/kubelogin completion fish >kubelogin.fish
    $out/bin/kubelogin completion zsh >kubelogin.zsh
    installShellCompletion kubelogin.{bash,fish,zsh}
  '';

  passthru.tests.version = testers.testVersion {
    package = kubelogin;
    version = "v${finalAttrs.version}";
  };

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Kubernetes credential plugin implementing Azure authentication";
    mainProgram = "kubelogin";
    inherit (finalAttrs.src.meta) homepage;
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})

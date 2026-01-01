{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "atlas";
<<<<<<< HEAD
  version = "1.0.0";
=======
  version = "0.38.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "ariga";
    repo = "atlas";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-Ls5N6HZFR3+KfuqoyE6gaaxhjZ/stQC+g1kWIUE8EaE=";
=======
    hash = "sha256-OS0UYrE+5spErR/S+7AsYDPcCce3EEWvcBBKh+8FkTo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  modRoot = "cmd/atlas";

  proxyVendor = true;
<<<<<<< HEAD
  vendorHash = "sha256-ksSvW+Sc1iQlMf9i6GWMjq4hISdAD3t/uAPlQ3x7wHU=";
=======
  vendorHash = "sha256-xlKU/hxSjQWSQV++7RHfY4hZhm2tWCPS6DcyaGNnmhc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X ariga.io/atlas/cmd/atlas/internal/cmdapi.version=v${finalAttrs.version}"
  ];

  subPackages = [ "." ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd atlas \
      --bash <($out/bin/atlas completion bash) \
      --fish <($out/bin/atlas completion fish) \
      --zsh <($out/bin/atlas completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "atlas version";
    version = "v${finalAttrs.version}";
  };

  meta = {
    description = "Manage your database schema as code";
    homepage = "https://atlasgo.io/";
    changelog = "https://github.com/ariga/atlas/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "atlas";
  };
})

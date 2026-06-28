{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

buildGoModule (finalAttrs: {
  __structuredAttrs = true;

  pname = "ocm-cli";
  version = "0.42.0";

  src = fetchFromGitHub {
    owner = "open-component-model";
    repo = "ocm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-c0xQB/OhVcRM2nY4M6NQrfIZPuPKoTClMs0sZ64s2iY=";
  };

  vendorHash = "sha256-zKIuued0MwEkQoOsRC98frEsEsFd+WCiz0fGRvH00lQ=";

  subPackages = [
    "cmds/ocm"
    "cmds/cliplugin"
    "cmds/demoplugin"
    "cmds/ecrplugin"
    "cmds/subcmdplugin"
    "cmds/jfrogplugin"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/open-component-model/ocm/pkg/version.version=${finalAttrs.version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ocm \
      --bash <($out/bin/ocm completion bash) \
      --zsh <($out/bin/ocm completion zsh) \
      --fish <($out/bin/ocm completion fish)
  '';

  meta = {
    description = "Open Component Model (OCM) is an open standard to describe software bills of delivery (SBOD)";
    longDescription = ''
      OCM is a technology-agnostic and machine-readable format focused on the software artifacts that must be delivered for software products.
      The specification is also used to express metadata needed for security, compliance, and certification purpose.
    '';
    homepage = "https://ocm.software";
    changelog = "https://github.com/open-component-model/ocm/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ h0nIg ];
    mainProgram = "ocm";
    platforms = lib.platforms.unix;
  };
})

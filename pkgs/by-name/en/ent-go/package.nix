{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  replaceVars,
}:

buildGoModule (finalAttrs: {
  pname = "ent-go";
  version = "0.14.6";

  src = fetchFromGitHub {
    owner = "ent";
    repo = "ent";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-pkD8MYyinvuKCtSpHGfFE9y8GRP40qdeyjhB32yeiK4=";
  };

  vendorHash = "sha256-CCjZv9ef/F+Cx6qmIkG/isX2Dd8WO/1mtjsJ4d8E3m0=";

  patches = [
    # patch in version information so we don't get "version = "(devel)";"
    (replaceVars ./ent_version.patch {
      inherit (finalAttrs) version;
      sum = finalAttrs.src.outputHash;
    })
  ];

  subPackages = [ "cmd/ent" ];

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ent \
      --bash <($out/bin/ent completion bash) \
      --fish <($out/bin/ent completion fish) \
      --zsh <($out/bin/ent completion zsh)
  '';

  meta = {
    description = "Entity framework for Go";
    homepage = "https://entgo.io/";
    changelog = "https://github.com/ent/ent/releases/tag/v${finalAttrs.version}";
    downloadPage = "https://github.com/ent/ent";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "ent";
  };
})

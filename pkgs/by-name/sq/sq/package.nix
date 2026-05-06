{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  sq,
}:

buildGoModule (finalAttrs: {
  pname = "sq";
  version = "0.50.2";

  src = fetchFromGitHub {
    owner = "neilotoole";
    repo = "sq";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ff4v6gMXi/dTmcdv/yz2tXpgT1LvTV+F9rnItWcziNU=";
  };

  vendorHash = "sha256-GFadKxTqs189PWqM2yCEeHhOnV2r7mh2KDHBOdvQN6U=";

  proxyVendor = true;

  nativeBuildInputs = [ installShellFiles ];

  # Some tests violates sandbox constraints.
  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/neilotoole/sq/cli/buildinfo.Version=v${finalAttrs.version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd sq \
      --bash <($out/bin/sq completion bash) \
      --fish <($out/bin/sq completion fish) \
      --zsh <($out/bin/sq completion zsh)
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = sq;
      version = "v${finalAttrs.version}";
    };
  };

  meta = {
    description = "Swiss army knife for data";
    mainProgram = "sq";
    homepage = "https://sq.io/";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ raitobezarius ];
  };
})

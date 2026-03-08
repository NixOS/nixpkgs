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
  version = "0.48.12";

  src = fetchFromGitHub {
    owner = "neilotoole";
    repo = "sq";
    rev = "v${finalAttrs.version}";
    hash = "sha256-TAQiTZx13rYlJlT41/RE03Ro4CRjECBdQz42YSI1j74=";
  };

  vendorHash = "sha256-jfUUVbvrdFX/++xRAgz7Tzqgu5AK2ZDmubWnWBIQeKE=";

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

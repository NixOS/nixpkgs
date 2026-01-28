{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  sq,
}:

buildGoModule rec {
  pname = "sq";
  version = "0.48.11";

  src = fetchFromGitHub {
    owner = "neilotoole";
    repo = "sq";
    rev = "v${version}";
    hash = "sha256-RxBBTVlIBC/29WtKOcYbvUn7zXwE5IcXPB+qKkIkp9A=";
  };

  vendorHash = "sha256-5hc9qO82lscy0xjrCgSMjW0DjBNQ6tUxVxUzThQFg4E=";

  proxyVendor = true;

  nativeBuildInputs = [ installShellFiles ];

  # Some tests violates sandbox constraints.
  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/neilotoole/sq/cli/buildinfo.Version=v${version}"
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
      version = "v${version}";
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
}

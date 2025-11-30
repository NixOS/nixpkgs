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
  version = "0.48.5";

  src = fetchFromGitHub {
    owner = "neilotoole";
    repo = "sq";
    rev = "v${version}";
    hash = "sha256-y7+UfwTbL0KTQgz4JX/q6QQqL0n8SO1qgKTrK9AFhO4=";
  };

  vendorHash = "sha256-MejUKPIhvjgV2+h81DJUSdBEMD0rvgDbTAvv3E2uTOk=";

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

  meta = with lib; {
    description = "Swiss army knife for data";
    mainProgram = "sq";
    homepage = "https://sq.io/";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ raitobezarius ];
  };
}

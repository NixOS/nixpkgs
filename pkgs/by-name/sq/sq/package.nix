{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  sq,
}:

buildGoModule rec {
  pname = "sq";
  version = "0.48.4";

  src = fetchFromGitHub {
    owner = "neilotoole";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-hg9BKeKly4uK3ib6CGETY/uZHXpxHqorU+YOjaUEiHE=";
  };

  vendorHash = "sha256-ofgEQ8vVfP/s9wjSgQKbmSx9Aeq9kv4gkUXkSHC4OOE=";

  proxyVendor = true;

  nativeBuildInputs = [ installShellFiles ];

  # Some tests violates sandbox constraints.
  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/neilotoole/sq/cli/buildinfo.Version=v${version}"
  ];

  postInstall = ''
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

{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  __structuredAttrs = true;

  pname = "multica-cli";
  version = "0.3.27";

  src = fetchFromGitHub {
    owner = "multica-ai";
    repo = "multica";
    rev = "v${version}";
    hash = "sha256-zHjyITvFG7dTk8mFQ62f8JY9wLbKeOvlo0pjF6hQxcI=";
  };

  sourceRoot = "${src.name}/server";

  vendorHash = "sha256-NXdBykPMWDD4BGLo2ams+KC14mxGNJYoV/dqobH6dv8=";

  subPackages = [ "cmd/multica" ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.commit=nixpkg"
    "-X main.date=1970-01-01T00:00:00Z"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd multica \
      --bash <($out/bin/multica completion bash) \
      --zsh <($out/bin/multica completion zsh) \
      --fish <($out/bin/multica completion fish)
  '';

  meta = {
    description = "CLI for the Multica managed agents platform";
    homepage = "https://github.com/multica-ai/multica";
    changelog = "https://github.com/multica-ai/multica/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ akosseres ];
    mainProgram = "multica";
  };
}

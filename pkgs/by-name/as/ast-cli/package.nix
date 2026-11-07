{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "ast-cli";
  version = "2.3.65";

  src = fetchFromGitHub {
    owner = "Checkmarx";
    repo = "ast-cli";
    rev = version;
    hash = "sha256-uFWHjZvrEKIq8hVwCgOZg+0be9RsPNZyvT0hX6lwbE4=";
  };

  vendorHash = "sha256-B3fMoLzC7MIEwe3i+o4sQj7gGWiDM7UtRxiiUJFnP90=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/checkmarx/ast-cli/internal/params.Version=${version}"
  ];

  # Upstream's tests are not sandbox-safe: they use production polling delays,
  # download the ASCA engine, and compare maps with assert.Equal.
  doCheck = false;

  __structuredAttrs = true;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    mv "$out/bin/cmd" "$out/bin/cx"
    installShellCompletion --cmd cx \
      --bash <("$out/bin/cx" completion bash) \
      --zsh <("$out/bin/cx" completion zsh) \
      --fish <("$out/bin/cx" completion fish)
  '';

  meta = {
    description = "A CLI project wrapping application security testing (AST) APIs";
    homepage = "https://github.com/Checkmarx/ast-cli";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ yechielw ];
    mainProgram = "cx";
  };
}

{
  buildGoModule,
  fetchFromGitHub,
  lib,
  installShellFiles,
}:

buildGoModule rec {
  pname = "cliproxyapi";
  version = "6.5.54";

  src = fetchFromGitHub {
    owner = "router-for-me";
    repo = "CLIProxyAPI";
    rev = "v${version}";
    hash = "sha256-eZSNB1d0ytuRICgQ+PJ04Om25Cc8CnnY9CKONhruEro=";
  };

  proxyVendor = true;
  vendorHash = "sha256-cWiomyc06eeCfjJ4/siPgQnGzd/nxN5qS2FT93qdC9U=";

  postInstall = ''
    mv $out/bin/server $out/bin/cli-proxy-api
  '';

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  env.CGO_ENABLED = false;
  subPackages = [ "cmd/server" ];
  nativeBuildInputs = [ installShellFiles ];

  doCheck = false;
  doInstallCheck = true;

  meta = {
    homepage = "https://github.com/router-for-me/CLIProxyAPI";
    description = "Wrap Gemini CLI, ChatGPT Codex, Claude Code, Qwen Code, iFlow as an OpenAI/Gemini/Claude/Codex compatible API service, allowing you to enjoy the free Gemini 2.5 Pro, GPT 5, Claude, Qwen model through API";
    maintainers = with lib.maintainers; [
      nipeharefa
    ];
    mainProgram = "cli-proxy-api";
    license = lib.licenses.mit;
  };
}

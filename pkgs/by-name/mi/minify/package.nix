{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  testers,
  minify,
}:

buildGoModule rec {
  pname = "minify";
  version = "2.23.11";

  src = fetchFromGitHub {
    owner = "tdewolff";
    repo = "minify";
    rev = "v${version}";
    hash = "sha256-38SO+2ajPG3tLb8adlcN0yIQ43ZLctlQlN5H46OgW6M=";
  };

  vendorHash = "sha256-qOe6vzXt2IO529ZGqfMsbPgfJUfWu1TNxfGO7E43CVw=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  subPackages = [ "cmd/minify" ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      inherit version;
      package = minify;
      command = "minify --version";
    };
  };

  postInstall = ''
    installShellCompletion --cmd minify --bash cmd/minify/bash_completion
  '';

  meta = {
    description = "Go minifiers for web formats";
    homepage = "https://go.tacodewolff.nl/minify";
    downloadPage = "https://github.com/tdewolff/minify";
    changelog = "https://github.com/tdewolff/minify/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gaelreyrol ];
    mainProgram = "minify";
  };
}

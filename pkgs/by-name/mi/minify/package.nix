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
  version = "2.24.8";

  src = fetchFromGitHub {
    owner = "tdewolff";
    repo = "minify";
    rev = "v${version}";
    hash = "sha256-sCEKc9WjLaryz8RAxUqftLySgsv50SQ9b+Q6DzDNbxI=";
  };

  vendorHash = "sha256-ugxHPZQlitskC0Xrzy0SNqYPbmm7Cl4sNhIzNR8DeqQ=";

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
    maintainers = [ ];
    mainProgram = "minify";
  };
}

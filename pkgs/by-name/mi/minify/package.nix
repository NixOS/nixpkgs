{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  testers,
  minify,
}:

buildGoModule (finalAttrs: {
  pname = "minify";
  version = "2.24.12";

  src = fetchFromGitHub {
    owner = "tdewolff";
    repo = "minify";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ZOe3CcYn3DSa4skgXe63F9gwX8qrX3RBSkqvuzJtN+o=";
  };

  vendorHash = "sha256-gH9HiNYAARImEdA4TESg8BXuedhs3Priv7dgZwcnrHU=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  subPackages = [ "cmd/minify" ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      inherit (finalAttrs) version;
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
    changelog = "https://github.com/tdewolff/minify/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "minify";
  };
})

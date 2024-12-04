{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, nix-update-script
, testers
, minify
}:

buildGoModule rec {
  pname = "minify";
  version = "2.21.1";

  src = fetchFromGitHub {
    owner = "tdewolff";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-CpZhKt+14pf10L84ijaPPoDKdHmGirAdUkRbQbwB+Kw=";
  };

  vendorHash = "sha256-WbEl6/dhWZ9TwW/Hc9GX5hbiKgjndMfyqizHD/hA5h0=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [ "-s" "-w" "-X main.Version=${version}" ];

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

  meta = with lib; {
    description = "Go minifiers for web formats";
    homepage = "https://go.tacodewolff.nl/minify";
    downloadPage = "https://github.com/tdewolff/minify";
    changelog = "https://github.com/tdewolff/minify/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ gaelreyrol ];
    mainProgram = "minify";
  };
}

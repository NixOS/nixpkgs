{
  lib,
  fetchFromGitHub,
  buildGoModule,
  go,
  imagemagick,
}:
buildGoModule rec {
  pname = "ahoy";
  version = "2.2.0";
  src = fetchFromGitHub {
    owner = "ahoy-cli";
    repo = "ahoy";
    rev = "v${version}";
    hash = "sha256-xwjfY9HudxVz3xEEyRPtWysbojtan56ABBL3KgG0J/8=";
  };
  vendorHash = null;
  outputs = [ "out" ];
  ldflags = [
    "-s -w -X main.version=${version} -X main.GitCommit= -X main.GitBranch= -X main.BuildTime="
  ];
  nativeBuildInputs = [ go ];
  buildInputs = [ imagemagick ];
  meta = {
    description = "Create self-documenting cli programs from YAML files. Easily wrap bash, grunt, npm, docker, (anything) to standardize your processes and make the lives of the people working on your project better.";
    homepage = "https://github.com/ahoy-cli/ahoy";
    changelog = "https://github.com/ahoy-cli/ahoy/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ darwincereska ];
    platforms = lib.platforms.linux;
    mainProgram = "ahoy";
  };
}

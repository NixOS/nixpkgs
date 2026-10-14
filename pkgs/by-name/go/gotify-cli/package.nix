{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "gotify-cli";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "gotify";
    repo = "cli";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-l6WiwAIxKSQnciyssY+dfEdn+GuCSrXdxxBNek4XRiA=";
  };

  vendorHash = "sha256-320MFcSPv05Zh/Lawq6ry+eemcsRpJu85LSd6TOZ8mM=";

  postInstall = ''
    mv $out/bin/cli $out/bin/gotify
  '';

  ldflags = [
    "-X main.Version=${finalAttrs.version}"
    "-X main.Commit=${finalAttrs.version}"
    "-X main.BuildDate=1970-01-01"
  ];

  meta = {
    license = lib.licenses.mit;
    homepage = "https://github.com/gotify/cli";
    description = "Command line interface for pushing messages to gotify/server";
    maintainers = [ ];
    mainProgram = "gotify";
  };
})

{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "buildkite-agent-metrics";
  version = "5.11.0";

  __darwinAllowLocalNetworking = true;

  outputs = [
    "out"
    "lambda"
  ];

  src = fetchFromGitHub {
    owner = "buildkite";
    repo = "buildkite-agent-metrics";
    rev = "v${version}";
    hash = "sha256-MoRtkP4Ozr/TXaZ5KTkQodGN/lcgVSMP2WmUk18n3DU=";
  };

  vendorHash = "sha256-jFHz6ox8n+k+AHBfmS1/+gfmcTbbLuwEbdND5gygTz8=";

  postInstall = ''
    mkdir -p $lambda/bin
    mv $out/bin/lambda $lambda/bin
  '';

  meta = with lib; {
    description = "Command-line tool (and Lambda) for collecting Buildkite agent metrics";
    homepage = "https://github.com/buildkite/buildkite-agent-metrics";
    license = licenses.mit;
    teams = [ teams.determinatesystems ];
  };
}

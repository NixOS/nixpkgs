{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "buildkite-agent-metrics";
  version = "5.10.0";

  __darwinAllowLocalNetworking = true;

  outputs = [
    "out"
    "lambda"
  ];

  src = fetchFromGitHub {
    owner = "buildkite";
    repo = "buildkite-agent-metrics";
    rev = "v${version}";
    hash = "sha256-QE4IY1yU8X1zG+jf7eBWiSjN3HvDqr2Avhs3Bub+xB0=";
  };

  vendorHash = "sha256-r088XQKYx0D0OVfz/nqhWL0LLCf4X13WqYikJKlLr3c=";

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

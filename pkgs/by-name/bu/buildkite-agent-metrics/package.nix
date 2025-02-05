{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "buildkite-agent-metrics";
  version = "5.9.13";

  outputs = [
    "out"
    "lambda"
  ];

  src = fetchFromGitHub {
    owner = "buildkite";
    repo = "buildkite-agent-metrics";
    rev = "v${version}";
    hash = "sha256-AVFQ3GP4YDQ6d9NSeol3Eobxzmoa9bRyCAKTsDbyZyQ=";
  };

  vendorHash = "sha256-RQmxYxTcQn5VEy8Z96EtArYBnODmde1RlV4CA6fhbZA=";

  postInstall = ''
    mkdir -p $lambda/bin
    mv $out/bin/lambda $lambda/bin
  '';

  meta = with lib; {
    description = "Command-line tool (and Lambda) for collecting Buildkite agent metrics";
    homepage = "https://github.com/buildkite/buildkite-agent-metrics";
    license = licenses.mit;
    maintainers = teams.determinatesystems.members;
  };
}

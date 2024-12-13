{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "buildkite-agent-metrics";
  version = "5.9.10";

  outputs = [
    "out"
    "lambda"
  ];

  src = fetchFromGitHub {
    owner = "buildkite";
    repo = "buildkite-agent-metrics";
    rev = "v${version}";
    hash = "sha256-2nN4Odx1GytI7WVnZHqepQsJKzfvj2ctkreWz3AgpR8=";
  };

  vendorHash = "sha256-YefdOc56TBKQZ6Ra4SpQwLTJYTZ2KuxRhRslaXIpucQ=";

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

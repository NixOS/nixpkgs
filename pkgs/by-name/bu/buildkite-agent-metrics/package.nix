{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "buildkite-agent-metrics";
  version = "5.9.12";

  outputs = [
    "out"
    "lambda"
  ];

  src = fetchFromGitHub {
    owner = "buildkite";
    repo = "buildkite-agent-metrics";
    rev = "v${version}";
    hash = "sha256-5k7njo8J96hb/RUdIRcP4KfwEH5Z2S4AyDyazcFlN0s=";
  };

  vendorHash = "sha256-zb+z1neus1mnJWeuI5DSc73cXMGWme0mz/PU2Z/Zam8=";

  postInstall = ''
    mkdir -p $lambda/bin
    mv $out/bin/lambda $lambda/bin
  '';

  meta = {
    description = "Command-line tool (and Lambda) for collecting Buildkite agent metrics";
    homepage = "https://github.com/buildkite/buildkite-agent-metrics";
    license = lib.licenses.mit;
    maintainers = lib.teams.determinatesystems.members;
  };
}

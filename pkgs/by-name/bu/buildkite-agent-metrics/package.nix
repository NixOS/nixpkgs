{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "buildkite-agent-metrics";
  version = "5.12.4";

  __darwinAllowLocalNetworking = true;

  outputs = [
    "out"
    "lambda"
  ];

  src = fetchFromGitHub {
    owner = "buildkite";
    repo = "buildkite-agent-metrics";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0pQhybD6RREqpB6Fa4L5HnPb54mh0QEylqHhl6mgGSQ=";
  };

  vendorHash = "sha256-kaObR5j6vsqRnU2jP4hJjC+Ek8X5v82T0AJsiHx6lvc=";

  # This is a Google Cloud Function and is not needed for compiling the binary
  excludedPackages = [ "./cloud_function" ];

  postInstall = ''
    mkdir -p $lambda/bin
    mv $out/bin/lambda $lambda/bin
  '';

  meta = {
    description = "Command-line tool (and Lambda) for collecting Buildkite agent metrics";
    homepage = "https://github.com/buildkite/buildkite-agent-metrics";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cbrxyz ];
  };
})

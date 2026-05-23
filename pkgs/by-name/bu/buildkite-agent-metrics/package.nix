{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "buildkite-agent-metrics";
  version = "5.12.3";

  __darwinAllowLocalNetworking = true;

  outputs = [
    "out"
    "lambda"
  ];

  src = fetchFromGitHub {
    owner = "buildkite";
    repo = "buildkite-agent-metrics";
    rev = "v${finalAttrs.version}";
    hash = "sha256-h6RPAqRNCcsT49d+D+q3FShoPZK4z7e8JCkB1FOHgNY=";
  };

  vendorHash = "sha256-2os2V1iyw1k6XwX2wLz0abMnu+X5p+Aqau7ajC3JIRc=";

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

{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "buildkite-agent-metrics";
  version = "5.13.0";

  __darwinAllowLocalNetworking = true;

  outputs = [
    "out"
    "lambda"
  ];

  src = fetchFromGitHub {
    owner = "buildkite";
    repo = "buildkite-agent-metrics";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mO+exMGQMHZUpwT5IqlDcLdYL+e0Fo+2/arhHFjixZI=";
  };

  vendorHash = "sha256-r2QeG5/6IOMhr+f53Xn3ehJ59+ZsOgW2oFfkJT04u6w=";

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

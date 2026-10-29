{
  lib,
  buildGoModule,
  fetchFromGitHub,
  systemdLibs,
}:

buildGoModule (finalAttrs: {
  pname = "coroot-node-agent";
  version = "1.36.1";

  src = fetchFromGitHub {
    owner = "coroot";
    repo = "coroot-node-agent";
    rev = "v${finalAttrs.version}";
    hash = "sha256-tFNzgelcA94tFNA7IAV66w8atIn7h0ABCsCOf6ISbfo=";
  };

  vendorHash = "sha256-qnmKY7pYkvVj0WOa3xm3Uxg7zZ3Y41USzf5Gdf+gHTM=";

  buildInputs = [ systemdLibs ];

  env.CGO_CFLAGS = "-I ${systemdLibs}/include";

  ldflags = [
    "-extldflags='-Wl,-z,lazy'"
    "-X 'github.com/coroot/coroot-node-agent/flags.Version=${finalAttrs.version}'"
  ];

  meta = {
    description = "Prometheus exporter based on eBPF";
    homepage = "https://github.com/coroot/coroot-node-agent";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      errnoh
      allsimon
    ];
    mainProgram = "coroot-node-agent";
  };
})

{
  lib,
  buildGoModule,
  fetchFromGitHub,
  systemdLibs,
}:

buildGoModule (finalAttrs: {
  pname = "coroot-node-agent";
  version = "1.37.0";

  src = fetchFromGitHub {
    owner = "coroot";
    repo = "coroot-node-agent";
    rev = "v${finalAttrs.version}";
    hash = "sha256-NbroHNYMToDFO4rx0lkQvAId0bfwyYn6XvR8XixCfzY=";
  };

  vendorHash = "sha256-IWobeAC/bByq+CpmWaPoOz7MLsgp6q1Qt99BibHcZKI=";

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

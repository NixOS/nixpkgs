{
  lib,
  buildGoModule,
  fetchFromGitHub,
  systemdLibs,
}:

buildGoModule (finalAttrs: {
  pname = "coroot-node-agent";
  version = "1.31.0";

  src = fetchFromGitHub {
    owner = "coroot";
    repo = "coroot-node-agent";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vS1nf20G++VKA/2WBhXvWjyGyVMPhshw+jUcPRxPcIw=";
  };

  vendorHash = "sha256-5+PwysNT3ZZ6epFDrH6BhIn0ERaxntO+ekqaBxc+qkA=";

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
    maintainers = with lib.maintainers; [ errnoh ];
    mainProgram = "coroot-node-agent";
  };
})

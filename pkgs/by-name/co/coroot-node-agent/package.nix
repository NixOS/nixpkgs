{
  lib,
  buildGoModule,
  fetchFromGitHub,
  systemdLibs,
}:

buildGoModule (finalAttrs: {
  pname = "coroot-node-agent";
  version = "1.35.5";

  src = fetchFromGitHub {
    owner = "coroot";
    repo = "coroot-node-agent";
    rev = "v${finalAttrs.version}";
    hash = "sha256-j/JSv7XOfRhxjJmjU9Fd3F4+ujhlIf7XBi8AD8GqMTs=";
  };

  vendorHash = "sha256-kP3IP4LZXJ5olm5uE9RtqCtvX3KfvOsscrZqo4I0fRA=";

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

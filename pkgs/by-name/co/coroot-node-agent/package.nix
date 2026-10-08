{
  lib,
  buildGoModule,
  fetchFromGitHub,
  systemdLibs,
}:

buildGoModule (finalAttrs: {
  pname = "coroot-node-agent";
  version = "1.35.8";

  src = fetchFromGitHub {
    owner = "coroot";
    repo = "coroot-node-agent";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JRivRViw3FJfHU6beGfH9bhGwYE9ODMi4BRNJylf+ak=";
  };

  vendorHash = "sha256-KZ+CkBJSx/4PjemMycyEuOHGg6hatsGirQWoYnfFyKo=";

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

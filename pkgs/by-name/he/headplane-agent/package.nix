{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule (finalAttrs: {
  pname = "hp_agent";
  # Note, if you are upgrading this, you should upgrade headplane at the same time
  version = "0.6.1";

  src = fetchFromGitHub {
    repo = "headplane";
    owner = "tale";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hsrnmEwKXJlPjV4aIfmS6GAE414ArVRGoPPpZGmV0x4=";
  };

  vendorHash = "sha256-MvrqKMD+A+qBZmzQv+T9920U5uJop+pjfJpZdm2ZqEA=";

  ldflags = [
    "-s"
    "-w"
  ];
  env.CGO_ENABLED = 0;

  meta = {
    description = "Optional sidecar process providing additional features for headplane";
    homepage = "https://github.com/tale/headplane";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.igor-ramazanov
      lib.maintainers.stealthbadger747
    ];
    mainProgram = "hp_agent";
    platforms = [
      lib.systems.aarch64-darwin
      lib.systems.aarch64-linux
      lib.systems.i686-linux
      lib.systems.x86_64-darwin
      lib.systems.x86_64-linux
    ];
  };
})

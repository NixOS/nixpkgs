{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "parca-debuginfo";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "parca-dev";
    repo = "parca-debuginfo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aFG4lMwiVZuuNq1+Q4Jz1+OywSy0oIF+VO7ZjDGQvi4=";
  };

  vendorHash = "sha256-bH7Y1y9BDMQJGtYfEaSrq+sWVLnovvV/uGbutJUXV2w=";

  ldflags = [
    "-X=main.version=${finalAttrs.version}"
    "-X=main.commit=${finalAttrs.src.rev}"
  ];

  meta = {
    description = "Command line utility for handling debuginfos";
    changelog = "https://github.com/parca-dev/parca-debuginfo/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/parca-dev/parca-debuginfo";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      brancz
      metalmatze
    ];
    platforms = lib.platforms.unix;
    mainProgram = "parca-debuginfo";
  };
})

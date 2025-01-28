{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "parca-debuginfo";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "parca-dev";
    repo = "parca-debuginfo";
    tag = "v${version}";
    hash = "sha256-FXi/iLVDdzyfClRD1tk0FQ9oF5zxW2dfGl4JuDPyZQE=";
  };

  vendorHash = "sha256-bH7Y1y9BDMQJGtYfEaSrq+sWVLnovvV/uGbutJUXV2w=";

  ldflags = [
    "-X=main.version=${version}"
    "-X=main.commit=${src.rev}"
  ];

  meta = {
    description = "Command line utility for handling debuginfos";
    changelog = "https://github.com/parca-dev/parca-debuginfo/releases/tag/v${version}";
    homepage = "https://github.com/parca-dev/parca-debuginfo";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jnsgruk ];
    platforms = lib.platforms.unix;
    mainProgram = "parca-debuginfo";
  };
}

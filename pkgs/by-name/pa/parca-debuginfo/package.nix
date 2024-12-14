{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "parca-debuginfo";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "parca-dev";
    repo = "parca-debuginfo";
    rev = "refs/tags/v${version}";
    hash = "sha256-gL1BgDtEf2Q7yxzpoiTJY+nsRlsWv3zYzLVvaVijMDM=";
  };

  vendorHash = "sha256-xtKkKhKQmZcCIFTOH+oM5a2cPlAWlJPRNQWfrAl2948=";

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

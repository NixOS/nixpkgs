{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "parca-debuginfo";
<<<<<<< HEAD
  version = "0.13.0";
=======
  version = "0.12.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "parca-dev";
    repo = "parca-debuginfo";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-aFG4lMwiVZuuNq1+Q4Jz1+OywSy0oIF+VO7ZjDGQvi4=";
=======
    hash = "sha256-tJ3Xc5b9XnTL460u11RkCmbIc41vHKql/oZ7enTaPgQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
    maintainers = with lib.maintainers; [
      brancz
      metalmatze
    ];
    platforms = lib.platforms.unix;
    mainProgram = "parca-debuginfo";
  };
}

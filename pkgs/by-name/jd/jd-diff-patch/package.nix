{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "jd-diff-patch";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "josephburnett";
    repo = "jd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-eaNP7cSJ0IxfHLmPaNAw5MQzD41AiOIjVbAjQkU8uec=";
  };

  sourceRoot = "${finalAttrs.src.name}/v2";

  # not including web ui
  excludedPackages = [
    "gae"
    "pack"
  ];

  vendorHash = "sha256-RerzCZL2soPNtl1hHWjdeNQNQ4VMlGYz3HNn4rTJSmU=";

  meta = {
    description = "Commandline utility and Go library for diffing and patching JSON values";
    homepage = "https://github.com/josephburnett/jd";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      juliusfreudenberger
    ];
    mainProgram = "jd";
  };
})

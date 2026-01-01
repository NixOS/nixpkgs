{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "jd-diff-patch";
<<<<<<< HEAD
  version = "2.3.1";
=======
  version = "2.3.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "josephburnett";
    repo = "jd";
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-HVbEVRe9u5D6Blfif9mEw9QZYJM7786GLB4njq3n+2U=";
=======
    hash = "sha256-eaNP7cSJ0IxfHLmPaNAw5MQzD41AiOIjVbAjQkU8uec=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

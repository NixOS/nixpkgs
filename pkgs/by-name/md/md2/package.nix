{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "md2";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "rapatao";
    repo = "md2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-H3X1u4BQ1dKZ/qdfjjrRWhPKGh5dGUK3raPrjTek8Qo=";
  };

  vendorHash = "sha256-6ZFEs7zWAVFTJ08UPEt3cAw8VRiEOjbtEEByI7E4UaU=";

  ldflags = [
    "-s"
    "-w"
    "-X"
    "main.version=${finalAttrs.version}"
  ];

  meta = {
    description = "Convert markdown files to PDF, HTML, and text";
    homepage = "https://github.com/rapatao/md2";
    license = lib.licenses.mit;
    mainProgram = "md2";
    maintainers = with lib.maintainers; [ rapatao ];
  };
})

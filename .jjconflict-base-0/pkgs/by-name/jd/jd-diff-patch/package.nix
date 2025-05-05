{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "jd-diff-patch";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "josephburnett";
    repo = "jd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-sA3NzCl9dR6cZnZNFa7Sqb1KUPSWA1h8ReZqR+SRjgk";
  };

  sourceRoot = "${finalAttrs.src.name}/v2";

  # not including web ui
  excludedPackages = [
    "gae"
    "pack"
  ];

  vendorHash = "sha256-Ol+9YwtJ5P6au1aW2ss9mrU9l5G3iBviX5q1qC0K+vc=";

  meta = {
    description = "Commandline utility and Go library for diffing and patching JSON values";
    homepage = "https://github.com/josephburnett/jd";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      bryanasdev000
      juliusfreudenberger
    ];
    mainProgram = "jd";
  };
})

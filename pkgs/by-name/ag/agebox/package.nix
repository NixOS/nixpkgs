{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "agebox";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "slok";
    repo = "agebox";
    tag = "v${version}";
    hash = "sha256-/FTNvGV7PsJmpSU1dI/kjfiY5G7shomvLd3bvFqORfg=";
  };

  vendorHash = "sha256-s3LZgQpUF0t9ETNloJux4gXXSn5Kg+pcuhJSMfWWnSo=";

  ldflags = [
    "-s"
    "-X main.Version=${version}"
  ];

  meta = {
    homepage = "https://github.com/slok/agebox";
    changelog = "https://github.com/slok/agebox/releases/tag/v${version}";
    description = "Age based repository file encryption gitops tool";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lesuisse ];
    mainProgram = "agebox";
  };
}

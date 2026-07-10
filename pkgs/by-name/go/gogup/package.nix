{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gogup";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "nao1215";
    repo = "gup";
    rev = "v${finalAttrs.version}";
    hash = "sha256-XRwYvXrg6sF15mvRpldru+mNBu1qKzntoLnhx5+CtOk=";
  };

  vendorHash = "sha256-uvyt/JVHX/R44NOZ8Hl0Jwzge9v3bph/Jy9kX4vNReQ=";
  doCheck = false;

  ldflags = [
    "-s"
    "-X github.com/nao1215/gup/internal/cmdinfo.Version=v${finalAttrs.version}"
  ];

  meta = {
    description = "Update binaries installed by 'go install' with goroutines";
    changelog = "https://github.com/nao1215/gup/blob/v${finalAttrs.version}/CHANGELOG.md";
    homepage = "https://github.com/nao1215/gup";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ phanirithvij ];
    mainProgram = "gup";
  };
})

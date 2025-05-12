{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "cloudprober";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "cloudprober";
    repo = "cloudprober";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t32mALyxtapPSzf/pNG0MGS2jjq0Dwm31qQZAlZI5zE=";
  };
  vendorHash = "sha256-u/glcoLlNXDEWFblnuvRHK9mUNCXTsfcWR+FDsJeOOA=";

  meta = with lib; {
    description = "Active monitoring software to detect failures before your customers do";
    mainProgram = "cloudprober";
    homepage = "https://cloudprober.org/";
    changelog = "https://github.com/cloudprober/cloudprober/releases/tag/${finalAttrs.src.tag}";
    license = licenses.apsl20;
    maintainers = with maintainers; [ juliusrickert ];
  };
})

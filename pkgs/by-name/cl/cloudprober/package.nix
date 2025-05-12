{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "cloudprober";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "cloudprober";
    repo = "cloudprober";
    rev = "v${version}";
    sha256 = "sha256-t32mALyxtapPSzf/pNG0MGS2jjq0Dwm31qQZAlZI5zE=";
  };
  vendorHash = "sha256-u/glcoLlNXDEWFblnuvRHK9mUNCXTsfcWR+FDsJeOOA=";

  meta = with lib; {
    description = "An active monitoring software to detect failures before your customers do";
    mainProgram = "cloudprober";
    homepage = "https://cloudprober.org/";
    changelog = "https://github.com/cloudprober/cloudprober/releases/tag/${src.rev}";
    license = licenses.apsl20;
    maintainers = with maintainers; [ juliusrickert ];
  };
}

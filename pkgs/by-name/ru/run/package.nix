{ lib, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "run";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "TekWizely";
    repo = "run";
    rev = "v${version}";
    sha256 = "sha256-an5AuRJJEM18IssdLLZC/zzPpsVCCtawRQXK/AfzMN0=";
  };

  vendorHash = "sha256-BAyhuE9hGGDfDGmXQ7dseUvHlK5vC87uLT78lHSvLeg=";

  doCheck = false;

  meta = with lib; {
    description = "Easily manage and invoke small scripts and wrappers";
    mainProgram = "run";
    homepage    = "https://github.com/TekWizely/run";
    license     = licenses.mit;
    maintainers = with maintainers; [ rawkode Br1ght0ne ];
  };
}

{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gogup";
  version = "0.27.5";

  src = fetchFromGitHub {
    owner = "nao1215";
    repo = "gup";
    rev = "v${version}";
    hash = "sha256-I4l/sDqafc/ZO8kKc4iOSMFLS0YZrAqRFOXn0N7Myo4=";
  };

  vendorHash = "sha256-rtdbPwVZHwofpGccYU8NBiaikzNMIwSDggbRdnGTBu8=";
  doCheck = false;

  ldflags = [
    "-s"
    "-X github.com/nao1215/gup/internal/cmdinfo.Version=v${version}"
  ];

  meta = with lib; {
    description = "Update binaries installed by 'go install' with goroutines";
    changelog = "https://github.com/nao1215/gup/blob/v${version}/CHANGELOG.md";
    homepage = "https://github.com/nao1215/gup";
    license = licenses.asl20;
    maintainers = with maintainers; [ phanirithvij ];
    mainProgram = "gup";
  };
}

{
  lib,
  buildGoModule,
  curl,
  fetchFromGitHub,
  pkg-config,
}:

buildGoModule rec {
  pname = "cameradar";
  version = "5.0.2";

  src = fetchFromGitHub {
    owner = "Ullaakut";
    repo = "cameradar";
    rev = "v${version}";
    sha256 = "sha256-GOqmz/aiOLGMfs9rQBIEQSgBycPzhu8BohcAc2U+gBw=";
  };

  vendorHash = "sha256-AIi57DWMvAKl0PhuwHO/0cHoDKk5e0bJsqHYBka4NiU=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    curl
  ];

  subPackages = [
    "cmd/cameradar"
  ];
  # At least one test is outdated
  #doCheck = false;

  meta = {
    description = "RTSP stream access tool";
    homepage = "https://github.com/Ullaakut/cameradar";
    changelog = "https://github.com/Ullaakut/cameradar/releases/tag/v${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
    # Upstream issue, doesn't build with latest curl, see
    # https://github.com/Ullaakut/cameradar/issues/320
    # https://github.com/andelf/go-curl/issues/84
    broken = true;
  };
}

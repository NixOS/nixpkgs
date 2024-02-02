{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "keep-sorted";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "keep-sorted";
    rev = "v${version}";
    hash = "sha256-qCR1JVDC/+NVz+CAY/2mMP8Sk71WDl2+Ig7QWwXTUrQ=";
  };

  vendorHash = "sha256-tPTWWvr+/8wWUnQcI4Ycco2OEgA2mDQt15OGCk/ZjrQ=";

  CGO_ENABLED = "0";

  ldfags = [ "-s" "-w" ];

  checkFlags = [
    # Test tries to find files using git
    "-skip=^TestGoldens"
  ];

  meta = {
    changelog = "https://github.com/google/keep-sorted/releases/tag/v${version}";
    description = "Language-agnostic formatter that sorts lines between two markers in a larger file";
    homepage = "https://github.com/google/keep-sorted";
    license = lib.licenses.asl20;
    mainProgram = "keep-sorted";
    maintainers = with lib.maintainers; [ katexochen ];
  };
}

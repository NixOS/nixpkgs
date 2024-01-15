{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "keep-sorted";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "keep-sorted";
    rev = "v${version}";
    hash = "sha256-bCV0XcwgyFTORl/RF1BS7vsM8DmU0Wox3OIEuZBrwSs=";
  };

  vendorHash = "sha256-yaeqfMAJbQdrqZ0uco6Y5T8vnfjlBJY4IQuGzZg3Ubw=";

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

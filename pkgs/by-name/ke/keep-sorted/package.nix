{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "keep-sorted";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "keep-sorted";
    rev = "v${version}";
    hash = "sha256-yeps+StUA7h12Jlra24Po2zNzjIPNIQCOyWLazC8F8M=";
  };

  vendorHash = "sha256-tPTWWvr+/8wWUnQcI4Ycco2OEgA2mDQt15OGCk/ZjrQ=";

  CGO_ENABLED = "0";

  ldfags = [
    "-s"
    "-w"
  ];

  checkFlags = [
    # Test tries to find files using git
    "-skip=^TestGoldens"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/google/keep-sorted/releases/tag/v${version}";
    description = "Language-agnostic formatter that sorts lines between two markers in a larger file";
    homepage = "https://github.com/google/keep-sorted";
    license = lib.licenses.asl20;
    mainProgram = "keep-sorted";
    maintainers = with lib.maintainers; [ katexochen ];
  };
}

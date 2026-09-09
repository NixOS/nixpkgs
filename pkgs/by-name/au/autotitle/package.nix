{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  go_1_26,
}:

buildGoModule.override { go = go_1_26; } rec {
  pname = "autotitle";
  version = "1.13.0";
  meta = with lib; {
    description = "A CLI tool and Go library for automatically renaming media files";
    homepage = "https://github.com/mydehq/autotitle";
    license = licenses.gpl3;
    mainProgram = "autotitle";
    maintainers = with maintainers; [ soymadip ];
  };

  src = fetchFromGitHub {
    owner = "mydehq";
    repo = "autotitle";
    rev = "v${version}";
    hash = "sha256-Gt9QBms9DcErj1lKP0SRYJOo46LiVyTfpTYlDwPtx7M=";
  };

  vendorHash = "sha256-Wgl6BluSEwwWvhI2TKM26DT2663Z95/5lGF9SVtSY40=";

  passthru.updateScript = nix-update-script { };
}

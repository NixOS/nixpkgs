{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "hyprls";
<<<<<<< HEAD
  version = "0.11.0";
=======
  version = "0.10.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "hyprland-community";
    repo = "hyprls";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-oKI5+SolS9fsgPcP8tTK8YVsnkC5YQSKO3dwMDlMwYo=";
  };

  vendorHash = "sha256-1oarMEG7kHxCPAg4oPTSJRjnrF0QmXShVQpTUnN9fFQ=";
=======
    hash = "sha256-N6A6j4uhBt64KTIcdhvicAhrLo2EuxwyGbCm5pijCCs=";
  };

  vendorHash = "sha256-QJyG3Kz/lSuuHpGLGDW8fjdhLZK6Pt7PtSPA8EY0ATM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  checkFlags = [
    # Not yet implemented
    "-skip=TestHighLevelParse"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "LSP server for Hyprland's configuration language";
    homepage = "https://gwen.works/hyprls";
    changelog = "https://github.com/hyprland-community/hyprls/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ arthsmn ];
    mainProgram = "hyprls";
  };
}

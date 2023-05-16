{ lib
, rustPlatform
, fetchCrate
}:
rustPlatform.buildRustPackage rec {
  pname = "krabby";
<<<<<<< HEAD
  version = "0.1.7";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-YI8OkNIDZWxAV+9n8AbKdZuWdA3A2cD94DuPgFvkokE=";
  };

  cargoHash = "sha256-j4zCuPmn/+ZSLFkAivNs3lH7YWVLvLA9k9RKbh43tUU=";
=======
  version = "0.1.6";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-BUX3D/UXJt9OxajUYaUDxI0u4t4ntSxqI1PMtk5IZNQ=";
  };

  cargoHash = "sha256-XynD19mlCmhHUCfbr+pmWkpb+D4+vt3bsgV+bpbUoaY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Print pokemon sprites in your terminal";
    homepage = "https://github.com/yannjor/krabby";
    changelog = "https://github.com/yannjor/krabby/releases/tag/v${version}";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ruby0b ];
  };
}

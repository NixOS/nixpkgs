{ lib
, rustPlatform
, fetchFromGitLab
}:

rustPlatform.buildRustPackage rec {
  pname = "swaysome";
  version = "2.1.1";

  src = fetchFromGitLab {
    owner = "hyask";
    repo = pname;
    rev = version;
    hash = "sha256-HRLMfpnqjDgkOIaH/7DxeYzoZn/0c0KUAmir8XIwesg=";
  };

  cargoHash = "sha256-e5B90tIiXxuaRseok69EN4xuoRlCyiTVgEcAqvVg/dM=";

  meta = with lib; {
    description = "Helper to make sway behave more like awesomewm";
    homepage = "https://gitlab.com/hyask/swaysome";
    license = licenses.mit;
    maintainers = with maintainers; [ esclear ];
    platforms = platforms.linux;
    mainProgram = "swaysome";
  };
}

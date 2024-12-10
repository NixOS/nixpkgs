{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "tuckr";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "RaphGL";
    repo = "Tuckr";
    rev = version;
    hash = "sha256-S4mHNCyK7WGYRBckxQkwA3+eu7QhUyKkOZ/KqhMJf+s=";
  };

  cargoHash = "sha256-aUhiMJUKV+Da3WLUY9Jr3oDB8yqcUm0pP05yKaITjM0=";

  doCheck = false; # test result: FAILED. 5 passed; 3 failed;

  meta = with lib; {
    description = "A super powered replacement for GNU Stow";
    homepage = "https://github.com/RaphGL/Tuckr";
    changelog = "https://github.com/RaphGL/Tuckr/releases/tag/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mimame ];
    mainProgram = "tuckr";
  };
}

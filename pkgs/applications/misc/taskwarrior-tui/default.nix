{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "taskwarrior-tui";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "kdheepak";
    repo = "taskwarrior-tui";
    rev = "v${version}";
    sha256 = "sha256-121TfmaWrWppsOiuF+8gxy+3J5YzbliYj88nw4aLt9w=";
  };

  # Because there's a test that requires terminal access
  doCheck = false;

  cargoSha256 = "sha256-oTb1pSA9g9cExCXKaQjNm+h5WB4bWuqODkU7MvvspGQ=";

  meta = with lib; {
    description = "A terminal user interface for taskwarrior ";
    homepage = "https://github.com/kdheepak/taskwarrior-tui";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}

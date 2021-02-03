{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "taskwarrior-tui";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "kdheepak";
    repo = "taskwarrior-tui";
    rev = "v${version}";
    sha256 = "1w8x3qfw7p4q8srdbamqlrz5nsilyd0dy87jp7kq2n7yxsrbyh4x";
  };

  # Because there's a test that requires terminal access
  doCheck = false;

  cargoSha256 = "0b69qyb74r9may6n61i5a5nzwhxpaij6y40bq6kh8rzdwy0awwx7";

  meta = with lib; {
    description = "A terminal user interface for taskwarrior ";
    homepage = "https://github.com/kdheepak/taskwarrior-tui";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}

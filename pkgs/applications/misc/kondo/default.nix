{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "kondo";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "tbillington";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-TTgsfoJ3TEK7wyRJfBIxvPA53wZbq7KJ4LxjUbrHE4Y=";
  };

  cargoSha256 = "sha256-s5e997I7YiDKF6rOB0XwcxbnHR8AifYPX9ctvdz8VTw=";

  meta = with lib; {
    description = "Save disk space by cleaning unneeded files from software projects";
    homepage = "https://github.com/tbillington/kondo";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}

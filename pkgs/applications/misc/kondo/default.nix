{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "kondo";
  version = "0.7";

  src = fetchFromGitHub {
    owner = "tbillington";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-m00zRNnryty96+pmZ2/ZFk61vy7b0yiWpomWzAHUAMk=";
  };

  cargoHash = "sha256-hG4bvcGYNwdNX9Wsdw30i3a3Ttxud+quNZpolgVKXQE=";

  meta = with lib; {
    description = "Save disk space by cleaning unneeded files from software projects";
    homepage = "https://github.com/tbillington/kondo";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}

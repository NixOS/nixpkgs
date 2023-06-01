{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "swayest-workstyle";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "Lyr-7D1h";
    repo = "swayest_workstyle";
    rev = version;
    sha256 = "sha256-N6z8xNT4vVULt8brOLlVAkJaqYnACMhoHJLGmyE7pZ0=";
  };

  cargoHash = "sha256-DiNhHuHUgJc9ea+EanaCybXzbrX2PEBdlR0h0zQQLn8=";

  doCheck = false; # No tests

  meta = with lib; {
    description = "Map sway workspace names to icons defined depending on the windows inside of the workspace";
    homepage = "https://github.com/Lyr-7D1h/swayest_workstyle";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ miangraham ];
    mainProgram = "sworkstyle";
  };
}

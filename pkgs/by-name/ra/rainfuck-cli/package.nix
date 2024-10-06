{ lib
, rustPlatform
, fetchFromGitLab
}:

rustPlatform.buildRustPackage rec {
  pname = "rainfuck-cli";
  version = "1.0.0";

  src = fetchFromGitLab {
    owner = "Oglo12";
    repo = "rainfuck-cli";
    rev = "dc9a885ef7daa4e4a60133c6114e582378978a85";
    hash = "sha256-hQ4xfwii6P3YphxQAwzY9wraNIiae9vyuLSEXq5xL6I=";
  };

  cargoHash = "sha256-n/ZWMEjSzyOBC9EVtGi9/13GnttCA5oqWlRcqan5gic=";

  meta = with lib; {
    description = "Run Brainfuck in the terminal";
    homepage = "https://gitlab.com/Oglo12/rainfuck-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ iogamaster ];
    mainProgram = "rainfuck-cli";
  };
}

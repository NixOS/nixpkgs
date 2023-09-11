{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "ripsecrets";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "sirwart";
    repo = "ripsecrets";
    rev = "v${version}";
    hash = "sha256-p3421sQko/WulSNUxXpjsHPAtRoHHg61angfxJpoyFg=";
  };

  cargoHash = "sha256-DJkEhqW5DZOmoNiS4nw+i2G0+KN2d7FbBuKp7fdAwMk=";

  meta = with lib; {
    description = "A command-line tool to prevent committing secret keys into your source code";
    homepage = "https://github.com/sirwart/ripsecrets";
    changelog = "https://github.com/sirwart/ripsecrets/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "ripsecrets";
  };
}

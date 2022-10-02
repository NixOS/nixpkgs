{ fetchFromGitHub, rustPlatform, lib }:

with lib;

rustPlatform.buildRustPackage rec {
  pname = "rm-improved";
  version = "0.13.0";

  cargoSha256 = "0wgpr6gx9dpvf02xgvrdbyiqfz1k9vipnvriz3jg0cz7n1afqisj";

  src = fetchFromGitHub {
    owner = "nivekuil";
    repo = "rip";
    rev = "0.13.0";
    sha256 = "0d065xia4mwdhxkiqfg7pic6scfzipzmsvvx7l6l97w62lzpiqx3";
  };

  meta = {
    description = "Replacement for rm with focus on safety, ergonomics and performance";
    homepage = "https://github.com/nivekuil/rip";
    maintainers = with maintainers; [ nils-degroot ];
    mainProgram = "rip";
    license = licenses.gpl3Plus;
  };
}

{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "md-tui";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "henriklovhaug";
    repo = pname;
    rev = "v${version}";
    hash = "";
  };

  cargoHash = "";

  meta = with lib; {
    description = "Markdown renderer in the terminal ";
    homepage = "https://github.com/henriklovhaug/md-tui";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ nydragon ];
    mainProgram = "mdt";
  };
}

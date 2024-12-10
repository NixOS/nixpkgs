{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "verco";
  version = "6.12.0";

  src = fetchFromGitHub {
    owner = "vamolessa";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-M3Utrt350I67kqzEH130tgBIiI7rY8ODCSxgMohWWWM=";
  };

  cargoSha256 = "sha256-urnTPlQTmOPq7mHZjsTqxql/FQe7NYHE8sVJJ4fno+U=";

  meta = with lib; {
    description = "A simple Git/Mercurial/PlasticSCM tui client based on keyboard shortcuts";
    homepage = "https://vamolessa.github.io/verco";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "verco";
  };
}

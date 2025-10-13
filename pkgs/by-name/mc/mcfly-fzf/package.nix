{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "mcfly-fzf";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "bnprks";
    repo = "mcfly-fzf";
    rev = version;
    hash = "sha256-ZdsbkN+/NLA0vor6/eEdAI7V5m5GEi+phcJQ89Jp4fk=";
  };

  postPatch = ''
    substituteInPlace shell/mcfly-fzf.bash --replace '$(command -v mcfly-fzf)' '${placeholder "out"}/bin/mcfly-fzf'
    substituteInPlace shell/mcfly-fzf.zsh --replace '$(command -v mcfly-fzf)' '${placeholder "out"}/bin/mcfly-fzf'
    substituteInPlace shell/mcfly-fzf.fish --replace '(command -v mcfly-fzf)' '${placeholder "out"}/bin/mcfly-fzf'
  '';

  cargoHash = "sha256-xHYOhq/vDmjP7RfgRR15Isj7rg/nIV9tz9XznHBENig=";

  meta = with lib; {
    homepage = "https://github.com/bnprks/mcfly-fzf";
    description = "Integrate Mcfly with fzf to combine a solid command history database with a widely-loved fuzzy search UI";
    license = licenses.mit;
    maintainers = [ maintainers.simonhammes ];
    mainProgram = "mcfly-fzf";
  };
}

{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "mcfly-fzf";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "bnprks";
    repo = "mcfly-fzf";
    rev = version;
    hash = "sha256-3QxiG9MR0BCKRjA8ue/Yb/AZ5SwiSdjn6qaOxSAK0SI=";
  };

  postPatch = ''
    substituteInPlace shell/mcfly-fzf.bash --replace '$(command -v mcfly-fzf)' '${placeholder "out"}/bin/mcfly-fzf'
    substituteInPlace shell/mcfly-fzf.zsh --replace '$(command -v mcfly-fzf)' '${placeholder "out"}/bin/mcfly-fzf'
    substituteInPlace shell/mcfly-fzf.fish --replace '(command -v mcfly-fzf)' '${placeholder "out"}/bin/mcfly-fzf'
  '';

  cargoHash = "sha256-pR5Fni/8iJuaDyWKrOnSanO50hvFXh73Qlgmd4a3Ucs=";

  meta = with lib; {
    homepage = "https://github.com/bnprks/mcfly-fzf";
    description = "Integrate Mcfly with fzf to combine a solid command history database with a widely-loved fuzzy search UI";
    license = licenses.mit;
    maintainers = [ maintainers.simonhammes ];
    mainProgram = "mcfly-fzf";
  };
}

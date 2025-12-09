{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-admonish";
  version = "1.20.0";

  src = fetchFromGitHub {
    owner = "tommilligan";
    repo = "mdbook-admonish";
    tag = "v${version}";
    hash = "sha256-5SVYfXXY1EmEMuhPHao3w9OzSayQDOWWvhL+1JoudzA=";
  };

  cargoHash = "sha256-PwYtqde8ZccMqlkKy7i/qjWDYsUoxs2cMWOWrChjMM4=";

  meta = {
    description = "Preprocessor for mdbook to add Material Design admonishments";
    mainProgram = "mdbook-admonish";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jmgilman
      Frostman
      matthiasbeyer
    ];
    homepage = "https://github.com/tommilligan/mdbook-admonish";
  };
}

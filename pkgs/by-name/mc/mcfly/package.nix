{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "mcfly";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "cantino";
    repo = "mcfly";
    rev = "v${version}";
    hash = "sha256-rptgy0y5Sgv2ultJEaTf286YRqvULFv9D13Gu+eTKmw=";
  };

  postPatch = ''
    substituteInPlace mcfly.bash --replace '$(command which mcfly)' '${placeholder "out"}/bin/mcfly'
    substituteInPlace mcfly.zsh  --replace '$(command which mcfly)' '${placeholder "out"}/bin/mcfly'
    substituteInPlace mcfly.fish --replace '(command which mcfly)'  '${placeholder "out"}/bin/mcfly'
  '';

  cargoHash = "sha256-GwalQjJ3ABdA8yfCh75KjTquS780XLIQ5y4oFrNiQUg=";

  meta = {
    homepage = "https://github.com/cantino/mcfly";
    description = "Upgraded ctrl-r where history results make sense for what you're working on right now";
    changelog = "https://github.com/cantino/mcfly/raw/v${version}/CHANGELOG.txt";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.melkor333 ];
    mainProgram = "mcfly";
  };
}

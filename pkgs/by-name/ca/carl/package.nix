{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "carl";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "b1rger";
    repo = "carl";
    rev = "v${version}";
    hash = "sha256-bUSQArlCfgJr/XJuuyMVNFOZzJlmpInaEGHHxRZsDW4=";
  };

  doCheck = false;

  cargoHash = "sha256-KueQLeqiHZfjyEdpURKXp6MigAcXdov8Z/KwKsiqv9Y=";

  meta = {
    description = "cal(1) with more features and written in rust";
    longDescription = ''
      Carl is a calendar for the commandline. It tries to mimic the various cal(1)
      implementations out there, but also adds enhanced features like colors and ical
      support
    '';
    homepage = "https://github.com/b1rger/carl";
    changelog = "https://github.com/b1rger/carl/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    mainProgram = "carl";
  };
}

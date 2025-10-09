{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "gdrive";
  version = "3.9.1";

  src = fetchFromGitHub {
    owner = "glotlabs";
    repo = "gdrive";
    rev = version;
    hash = "sha256-1yJg+rEhKTGXC7mlHxnWGUuAm9/RwhD6/Xg/GBKyQMw=";
  };

  cargoHash = "sha256-ZIswHJBV1uwrnSm5BmQgb8tVD1XQMTQXQ5DWvBj1WDk=";

  meta = with lib; {
    description = "Google Drive CLI Client";
    homepage = "https://github.com/glotlabs/gdrive";
    changelog = "https://github.com/glotlabs/gdrive/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "gdrive";
  };
}

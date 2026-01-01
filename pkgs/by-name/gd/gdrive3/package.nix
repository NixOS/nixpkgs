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

<<<<<<< HEAD
  meta = {
    description = "Google Drive CLI Client";
    homepage = "https://github.com/glotlabs/gdrive";
    changelog = "https://github.com/glotlabs/gdrive/releases/tag/${src.rev}";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Google Drive CLI Client";
    homepage = "https://github.com/glotlabs/gdrive";
    changelog = "https://github.com/glotlabs/gdrive/releases/tag/${src.rev}";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
    mainProgram = "gdrive";
  };
}

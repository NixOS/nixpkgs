{ lib, fetchFromGitHub }:
rec {
  version = "1.5.29";

  src = fetchFromGitHub {
    owner = "TandoorRecipes";
    repo = "recipes";
    rev = version;
    hash = "sha256-NfU071BLZ/NtpbZe475oNl8LGiVzVix9iekEoCGtcdk=";
  };

  yarnHash = "sha256-lU8QrTkI32XOHefIkj/0fa2UKhuZpQIT1wyweQnzXmQ=";

  meta = with lib; {
    homepage = "https://tandoor.dev/";
    changelog = "https://github.com/TandoorRecipes/recipes/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ jvanbruegge ];
  };
}

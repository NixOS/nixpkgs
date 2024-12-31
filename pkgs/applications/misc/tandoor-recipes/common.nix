{ lib, fetchFromGitHub }:
rec {
  version = "1.5.25";

  src = fetchFromGitHub {
    owner = "TandoorRecipes";
    repo = "recipes";
    rev = version;
    hash = "sha256-Yw68wxLqoyPRQmP/krSaxByv24CKh7Y7O07NU+dL5mo=";
  };

  yarnHash = "sha256-lU8QrTkI32XOHefIkj/0fa2UKhuZpQIT1wyweQnzXmQ=";

  meta = with lib; {
    homepage = "https://tandoor.dev/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ jvanbruegge ];
  };
}

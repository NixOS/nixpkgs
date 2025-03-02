{ lib, fetchFromGitHub }:
rec {
  version = "1.5.31";

  src = fetchFromGitHub {
    owner = "TandoorRecipes";
    repo = "recipes";
    rev = version;
    hash = "sha256-58ysUfjQD2aNh+dA9kSzHMgpVhMrSfDwvgpfmoaWIjI=";
  };

  yarnHash = "sha256-lU8QrTkI32XOHefIkj/0fa2UKhuZpQIT1wyweQnzXmQ=";

  meta = with lib; {
    homepage = "https://tandoor.dev/";
    changelog = "https://github.com/TandoorRecipes/recipes/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ jvanbruegge ];
  };
}

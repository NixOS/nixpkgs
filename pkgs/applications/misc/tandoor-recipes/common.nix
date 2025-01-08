{ lib, fetchFromGitHub }:
rec {
  version = "1.5.27";

  src = fetchFromGitHub {
    owner = "TandoorRecipes";
    repo = "recipes";
    rev = version;
    hash = "sha256-HP4gVk127hvvL337Cb4Wbvvf55RWY7u5RF/FKDCottw=";
  };

  yarnHash = "sha256-lU8QrTkI32XOHefIkj/0fa2UKhuZpQIT1wyweQnzXmQ=";

  meta = with lib; {
    homepage = "https://tandoor.dev/";
    changelog = "https://github.com/TandoorRecipes/recipes/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ jvanbruegge ];
  };
}

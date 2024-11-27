{ lib, fetchFromGitHub }:
rec {
  version = "1.5.24";

  src = fetchFromGitHub {
    owner = "TandoorRecipes";
    repo = "recipes";
    rev = version;
    hash = "sha256-E6mpt4blt3fzaKJMqmCm5qUEE7XHgCJBHVOjV0rI4FA=";
  };

  yarnHash = "sha256-lU8QrTkI32XOHefIkj/0fa2UKhuZpQIT1wyweQnzXmQ=";

  meta = with lib; {
    homepage = "https://tandoor.dev/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ ambroisie ];
  };
}

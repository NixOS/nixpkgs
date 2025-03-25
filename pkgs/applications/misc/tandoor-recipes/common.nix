{ lib, fetchFromGitHub }:
rec {
  version = "1.5.33";

  src = fetchFromGitHub {
    owner = "TandoorRecipes";
    repo = "recipes";
    rev = version;
    hash = "sha256-94sJYYiD0u5hP97hzWQxSvAGrAid36drplgFgVmwzQ0=";
  };

  yarnHash = "sha256-CFPofExwhvto6FVBXdsEY/uZaVKPkWaSdfqkEV7KY70=";

  meta = with lib; {
    homepage = "https://tandoor.dev/";
    changelog = "https://github.com/TandoorRecipes/recipes/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ jvanbruegge ];
  };
}

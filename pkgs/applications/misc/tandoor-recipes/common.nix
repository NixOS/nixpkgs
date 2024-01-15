{ lib, fetchFromGitHub }:
rec {
  version = "1.5.10";

  src = fetchFromGitHub {
    owner = "TandoorRecipes";
    repo = "recipes";
    rev = version;
    hash = "sha256-CkqNPG57e76TT/vF9lscS6m2FbXOvOfqiT/9aM2Il9E=";
  };

  yarnHash = "sha256-atl2XrY9LmWh2USp6K2W50/khEsnY6OqKBUS26Ln9ZM=";

  meta = with lib; {
    homepage = "https://tandoor.dev/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ ambroisie ];
  };
}

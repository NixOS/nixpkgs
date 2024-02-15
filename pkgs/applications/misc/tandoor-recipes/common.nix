{ lib, fetchFromGitHub }:
rec {
  version = "1.5.12";

  src = fetchFromGitHub {
    owner = "TandoorRecipes";
    repo = "recipes";
    rev = version;
    hash = "sha256-5UslXRoiq9cipGCOiqpf+rv7OPTsW4qpVTjakNeg4ug=";
  };

  yarnHash = "sha256-CresovsRh+dLHGnv49fCi/i66QXOS3SnzfFNvkVUfd8=";

  meta = with lib; {
    homepage = "https://tandoor.dev/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ ambroisie ];
  };
}

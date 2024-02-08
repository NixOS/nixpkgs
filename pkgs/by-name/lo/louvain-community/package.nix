{ stdenv
, fetchFromGitHub
, cmake
, lib
, unstableGitUpdater
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "louvain-community";
  version = "unstable-2024-01-30";

  src = fetchFromGitHub {
    owner = "meelgroup";
    repo = "louvain-community";
    rev = "681a711a530ded0b25af72ee4881d453a80ac8ac";
    hash = "sha256-mp2gneTtm/PaCqz4JNOZgdKmFoV5ZRVwNYjHc4s2KuY=";
  };

  nativeBuildInputs = [ cmake ];

  passthru.updateScript = unstableGitUpdater {};

  meta = with lib; {
    description = "Louvain Community Detection Library";
    homepage = "https://github.com/meelgroup/louvain-community";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ t4ccer ];
    platforms = platforms.unix;
  };
})

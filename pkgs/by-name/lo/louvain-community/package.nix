{ stdenv
, fetchFromGitHub
, cmake
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "louvain-community";
  version = "unstable-2021-03-18";

  src = fetchFromGitHub {
    owner = "meelgroup";
    repo = "louvain-community";
    rev = "8cc5382d4844af127b1c1257373740d7e6b76f1e";
    hash = "sha256-0i3wrDdOyleOPv5iVO1YzPfTPnIdljLabCvl3SYEQOs=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Louvain Community Detection Library";
    homepage = "https://github.com/meelgroup/louvain-community";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ t4ccer ];
    platforms = platforms.unix;
  };
})

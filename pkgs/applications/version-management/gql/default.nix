{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libgit2
, zlib
, cmake
}:

rustPlatform.buildRustPackage rec {
  pname = "gql";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "AmrDeveloper";
    repo = "GQL";
    rev = version;
    hash = "sha256-/cL/Ts5RbClGqs5D93RTC7A5fr6Ca1c1sNbVZE4zK+E=";
  };

  cargoHash = "sha256-o9eTOauQF5sf8UPyG0os2NQLsNkAIUOGhmMsZo6Kncw=";

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [
    libgit2
    zlib
  ];

  meta = with lib; {
    description = "SQL like query language to perform queries on .git files";
    homepage = "https://github.com/AmrDeveloper/GQL";
    changelog = "https://github.com/AmrDeveloper/GQL/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "gitql";
  };
}

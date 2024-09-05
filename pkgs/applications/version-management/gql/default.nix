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
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "AmrDeveloper";
    repo = "GQL";
    rev = version;
    hash = "sha256-qVO+kqsmVFDsO9fJGLyqxBzlBc8DZmX1ZQ7UjI3T0Fw=";
  };

  cargoHash = "sha256-sq8hxI1MOOE97OwrUEkwrEkpQWeCTzA8r6x5abTxCl0=";

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

{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  zlib,
  cmake,
}:

rustPlatform.buildRustPackage rec {
  pname = "gql";
  version = "0.29.1";

  src = fetchFromGitHub {
    owner = "AmrDeveloper";
    repo = "GQL";
    rev = version;
    hash = "sha256-Py2wTWuUfr6Poxtab4JikG4D7Iv6mBocLEbn0zgz+k8=";
  };

  cargoHash = "sha256-BAaHnBkTmk58uAnZyZ7id1WmKz/HiOKSvdZApmgk6rs=";

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

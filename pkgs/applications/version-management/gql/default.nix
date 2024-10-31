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
  version = "0.28.0";

  src = fetchFromGitHub {
    owner = "AmrDeveloper";
    repo = "GQL";
    rev = version;
    hash = "sha256-BA94Q8nRf4NptVBHSMYLMEklB9vHaXRU1+o7shXhkZQ=";
  };

  cargoHash = "sha256-L+o0ZhTI7x01DpGuhWrvzvSZDYHc++31svWTJ41qx90=";

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

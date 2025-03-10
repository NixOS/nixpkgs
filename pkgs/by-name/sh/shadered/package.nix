{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  sfml,
  glm,
  python3,
  glew,
  pkg-config,
  SDL2,
}:

stdenv.mkDerivation rec {
  pname = "SHADERed";
  version = "1.5.6";

  src = fetchFromGitHub {
    owner = "dfranx";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-WTpEhBxhVKYhmwpzcQJ21vd7j5feCyyFiJU90DlHLjc=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    SDL2
    glew
    glm
    python3
    sfml
  ];

  patches = [
    ./install_path_fix.patch
    ./0001-treewide-add-missing-includes.patch
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=format-security";

  meta = with lib; {
    description = "Lightweight, cross-platform & full-featured shader IDE";
    homepage = "https://github.com/dfranx/SHADERed";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}

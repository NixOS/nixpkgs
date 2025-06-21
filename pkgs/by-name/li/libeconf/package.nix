{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  meson,
  ninja,
}:

stdenv.mkDerivation rec {
  pname = "libeconf";
  version = "0.7.9";

  src = fetchFromGitHub {
    owner = "openSUSE";
    repo = "libeconf";
    rev = "v${version}";
    hash = "sha256-wJDRVq7Pnj+xO4g8OUA9dQ8Tdz6RCuvE2nV3KZWz6lA=";
  };

  patches = [
    ./cmake-install-paths.patch
  ];

  nativeBuildInputs = [
    cmake
    meson
    ninja
  ];

  meta = {
    description = "Enhanced config file parser, which merges config files placed in several locations into one";
    homepage = "https://github.com/openSUSE/libeconf";
    changelog = "https://github.com/openSUSE/libeconf/blob/${src.rev}/NEWS";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "libeconf";
    platforms = lib.platforms.all;
  };
}

{
  lib,
  stdenv,
  fetchFromGitHub,
  tbb_2021_11,
  libgit2,
  curl,
  fmt,
  nlohmann_json,
  pkg-config,
  git,
}:

let
  toml11 = fetchFromGitHub rec {
    owner = "ToruNiina";
    repo = "toml11";
    version = "4.2.0";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-NUuEgTpq86rDcsQnpG0IsSmgLT0cXhd1y32gT57QPAw=";
  };
in
stdenv.mkDerivation rec {
  pname = "poac";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "poac-dev";
    repo = pname;
    leaveDotGit = true;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-uUVNM70HNJwrr38KB+44fNvLpWihoKyDpRj7d7kbo7k=";
  };

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    libgit2
    fmt
    tbb_2021_11
    nlohmann_json
    curl
    git
  ];
  configurePhase = ''
    #Skip git clone toml11
    substituteInPlace Makefile \
       --replace-fail "git clone" "\#git clone"
    substituteInPlace Makefile \
       --replace-fail "git -C" "\#git -c"
  '';
  buildPhase = ''
    mkdir -p build-out/DEPS/
    cp -rf ${toml11} build-out/DEPS/toml11
    make RELEASE=1
  '';
  installPhase = ''
    make install PREFIX=$out
  '';
  meta = {
    homepage = "https://poac.dev";
    description = "A package manager and build system for C++";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.qwqawawow ];
    platforms = lib.platforms.unix;
    mainProgram = "poac";
  };
}

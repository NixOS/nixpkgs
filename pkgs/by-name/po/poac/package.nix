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
    rev = "refs/tags/${version}";
    sha256 = "sha256-uUVNM70HNJwrr38KB+44fNvLpWihoKyDpRj7d7kbo7k=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    fmt
    tbb_2021_11
    nlohmann_json
    curl
  ];

  preConfigure = ''
    #Skip git clone toml11
    substituteInPlace Makefile \
       --replace-fail "git clone" "\#git clone"
    substituteInPlace Makefile \
       --replace-fail "git -C" "\#git -c"
  '';

  preBuild = ''
    mkdir -p build-out/DEPS/
    cp -rf ${toml11} build-out/DEPS/toml11
  '';

  makeFlags = [ "RELEASE=1" ];

  installFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    broken = (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64);
    homepage = "https://poac.dev";
    description = "A package manager and build system for C++";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.qwqawawow ];
    platforms = lib.platforms.unix;
    mainProgram = "poac";
  };
}

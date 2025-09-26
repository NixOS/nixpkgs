{
  lib,
  stdenv,
  fetchFromGitHub,
  tbb_2022,
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
    tag = "v${version}";
    sha256 = "sha256-NUuEgTpq86rDcsQnpG0IsSmgLT0cXhd1y32gT57QPAw=";
  };
in
stdenv.mkDerivation rec {
  pname = "cabinpkg";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "cabinpkg";
    repo = "cabin";
    tag = version;
    sha256 = "sha256-qMmfViu3ol8+Tpyy8hn0j5r+bql0SFeKPVVj/ox4AGQ=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    fmt
    tbb_2022
    nlohmann_json
    curl
  ];

  # Skip git cloning toml11
  preConfigure = ''
    substituteInPlace Makefile \
       --replace-fail "git clone https://github.com/ToruNiina/toml11.git \$@" ":" \
       --replace-fail "git -C \$@ reset --hard v4.2.0" ":"
  '';

  preBuild = ''
    mkdir -p build/DEPS/
    cp -rf ${toml11} build/DEPS/toml11
  '';

  makeFlags = [
    "RELEASE=1"
    "COMMIT_HASH="
    "COMMIT_SHORT_HASH="
    "COMMIT_DATE="
  ];

  installFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    broken = (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64);
    homepage = "https://cabinpkg.com";
    description = "Package manager and build system for C++";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.eihqnh ];
    platforms = lib.platforms.unix;
    mainProgram = "cabin";
  };
}

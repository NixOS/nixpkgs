{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  onetbb,
  libgit2,
  curl,
  fmt,
  nlohmann_json,
  spdlog,
  pkg-config,
}:

let
  toml11 = fetchFromGitHub rec {
    owner = "ToruNiina";
    repo = "toml11";
    version = "4.4.0";
    tag = "v${version}";
    sha256 = "sha256-sgWKYxNT22nw376ttGsTdg0AMzOwp8QH3E8mx0BZJTQ=";
  };
  mitama-cpp-result = fetchFromGitHub rec {
    owner = "loliGothicK";
    repo = "mitama-cpp-result";
    version = "11.0.0";
    tag = "v${version}";
    sha256 = "sha256-YqC19AarJgz5CagNI1wyHGJ3xoUeeufDDbjFvQwDOjo=";
  };
in
stdenv.mkDerivation rec {
  pname = "cabinpkg";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "cabinpkg";
    repo = "cabin";
    tag = version;
    sha256 = "sha256-bCbxTVlb9IgiBrOfe2nkkupXMWcuFeNR6hJUjmqC8HA=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    fmt
    onetbb
    nlohmann_json
    curl
    spdlog
  ];

  # Skip git cloning dependenicies
  preConfigure = ''
    substituteInPlace Makefile \
       --replace-fail "git clone https://github.com/ToruNiina/toml11.git \$@" ":" \
       --replace-fail 'git -C $@ reset --hard $(TOML11_VER)' ":" \
       --replace-fail 'git clone https://github.com/loliGothicK/mitama-cpp-result.git $@' ":" \
       --replace-fail 'git -C $@ reset --hard $(RESULT_VER)' ":"
  '';

  preBuild = ''
    mkdir -p build/DEPS/
    cp -rf ${toml11} build/DEPS/toml11
    cp -rf ${mitama-cpp-result} build/DEPS/mitama-cpp-result
  '';
  patches = [
    (fetchpatch {
      url = "https://github.com/cabinpkg/cabin/commit/94bffea6e57cee5bbb3c84d0bfd9d98548901158.patch";
      name = "allow-fmt-12.patch";
      hash = "sha256-aJ4ayPQfElcQ4TYjuGI9t9I1adHsRh1e/WnaSnOxEdw=";
    })
  ];

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
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "cabin";
  };
}

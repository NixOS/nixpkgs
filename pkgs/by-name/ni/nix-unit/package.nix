{ stdenv
, lib
, boost
, clang-tools
, cmake
, difftastic
, makeWrapper
, meson
, ninja
, nixVersions
, nlohmann_json
, pkg-config
, fetchFromGitHub
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nix-unit";
  version = "2.23.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nix-unit";
    rev = "v${finalAttrs.version}";
    hash = "sha256-sDYeiwVo6+GL4/AHadeExVqE9j3wzdUsyMLs1OYQW7Y=";
  };

  buildInputs = [
    nlohmann_json
    # We pin the nix version to a known working one here as upgrades can likely break the build.
    # Since the nix language is rather stable we don't always need to have the latest and greatest for unit tests
    # On each update of nix unit we should re-evaluate what version we need.
    nixVersions.nix_2_23
    boost
  ];

  nativeBuildInputs = [
    makeWrapper
    meson
    pkg-config
    ninja
    # nlohmann_json can be only discovered via cmake files
    cmake
  ] ++ lib.optional stdenv.cc.isClang [ clang-tools ];

  postInstall = ''
    wrapProgram "$out/bin/nix-unit" --prefix PATH : ${difftastic}/bin
  '';

  meta = {
    description = "Nix unit test runner";
    homepage = "https://github.com/nix-community/nix-unit";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ mic92 adisbladis ];
    platforms = lib.platforms.unix;
    mainProgram = "nix-unit";
  };
})

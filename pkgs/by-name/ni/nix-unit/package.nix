{
  stdenv,
  lib,
  boost,
  clang-tools,
  cmake,
  difftastic,
  makeWrapper,
  meson,
  ninja,
  nixVersions,
  nlohmann_json,
  pkg-config,
  fetchFromGitHub,
  # Override to link nix-unit against a different Nix version; must
  # expose nix-main, nix-store, nix-expr, nix-cmd, nix-flake.
  nixComponents ? nixVersions.nixComponents_2_30,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "nix-unit";
  version = "2.30.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nix-unit";
    rev = "v${finalAttrs.version}";
    hash = "sha256-yQ7HqzfrG7B6Sq1iGBI7QJsbkI/07Ccz42bqWJW4NJA=";
  };

  buildInputs = [
    nixComponents.nix-main
    nixComponents.nix-store
    nixComponents.nix-expr
    nixComponents.nix-cmd
    nixComponents.nix-flake
    nlohmann_json
    boost
  ];

  nativeBuildInputs = [
    makeWrapper
    meson
    pkg-config
    ninja
    # nlohmann_json can be only discovered via cmake files
    cmake
  ]
  ++ lib.optional stdenv.cc.isClang [ clang-tools ];

  postInstall = ''
    wrapProgram "$out/bin/nix-unit" --prefix PATH : ${difftastic}/bin
  '';

  meta = {
    description = "Nix unit test runner";
    homepage = "https://github.com/nix-community/nix-unit";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      mic92
      adisbladis
    ];
    platforms = lib.platforms.unix;
    mainProgram = "nix-unit";
  };
})

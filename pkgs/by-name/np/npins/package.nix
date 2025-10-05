{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,

  # runtime dependencies
  nix-prefetch-git,
  git, # for git ls-remote
}:

let
  runtimePath = lib.makeBinPath [
    nix-prefetch-git
    git
  ];
in
rustPlatform.buildRustPackage rec {
  pname = "npins";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "andir";
    repo = "npins";
    tag = version;
    sha256 = "sha256-PPk9Ve1pM3X7NfGeGb8Jiq4YDEwAjErP4xzGwLaakTU=";
  };

  cargoHash = "sha256-YRW2TqbctuGC2M6euR4bb0m9a19m8WQVvWucRMpzkQE=";
  buildNoDefaultFeatures = true;
  buildFeatures = [
    "clap"
    "crossterm"
    "env_logger"
  ];

  nativeBuildInputs = [ makeWrapper ];

  # (Almost) all tests require internet
  doCheck = false;

  postFixup = ''
    wrapProgram $out/bin/npins --prefix PATH : "${runtimePath}"
  '';

  meta = with lib; {
    description = "Simple and convenient dependency pinning for Nix";
    mainProgram = "npins";
    homepage = "https://github.com/andir/npins";
    license = licenses.eupl12;
    maintainers = with maintainers; [ piegames ];
  };
}

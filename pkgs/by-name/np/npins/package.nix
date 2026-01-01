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
<<<<<<< HEAD
  version = "0.4.0";
=======
  version = "0.3.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "andir";
    repo = "npins";
    tag = version;
<<<<<<< HEAD
    sha256 = "sha256-ksOXi7u4bpHyWNHwkUR62fdwKowPW5GqBS7MA7Apwh4=";
  };

  cargoHash = "sha256-A93cFkBt+gHCuLAE7Zk8DRmsGoMwJkqtgHZd4lbpFs0=";
=======
    sha256 = "sha256-PPk9Ve1pM3X7NfGeGb8Jiq4YDEwAjErP4xzGwLaakTU=";
  };

  cargoHash = "sha256-YRW2TqbctuGC2M6euR4bb0m9a19m8WQVvWucRMpzkQE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Simple and convenient dependency pinning for Nix";
    mainProgram = "npins";
    homepage = "https://github.com/andir/npins";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [ piegames ];
=======
  meta = with lib; {
    description = "Simple and convenient dependency pinning for Nix";
    mainProgram = "npins";
    homepage = "https://github.com/andir/npins";
    license = licenses.eupl12;
    maintainers = with maintainers; [ piegames ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

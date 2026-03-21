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
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "npins";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "andir";
    repo = "npins";
    tag = finalAttrs.version;
    sha256 = "sha256-ksOXi7u4bpHyWNHwkUR62fdwKowPW5GqBS7MA7Apwh4=";
  };

  cargoHash = "sha256-A93cFkBt+gHCuLAE7Zk8DRmsGoMwJkqtgHZd4lbpFs0=";
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

  meta = {
    description = "Simple and convenient dependency pinning for Nix";
    mainProgram = "npins";
    homepage = "https://github.com/andir/npins";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [ piegames ];
  };
})

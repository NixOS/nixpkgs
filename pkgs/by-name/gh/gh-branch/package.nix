{
  stdenv,
  lib,
  fetchFromGitHub,
  pkgs,
}:

stdenv.mkDerivation {
  pname = "gh-branch";
  version = "0-unstable-2023-12-06";

  src = fetchFromGitHub {
    owner = "mislav";
    repo = "gh-branch";
    rev = "7ed0aff7601dc4162e0cac8835ecd73409d8a009";
    hash = "sha256-yiRSXU/jLi067i+gBb3cEHTOuo+w3oEVsGL0NN6shl8=";
  };

  propagatedBuildInputs = with pkgs; [
    fzf
    gh
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 $src/gh-branch $out/bin/gh-branch

    runHook postInstall
  '';

  meta = {
    description = "GitHub CLI extension for fuzzy finding, quickly switching between and deleting branches";
    homepage = "https://github.com/mislav/gh-branch";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ starsep ];
    mainProgram = "gh-branch";
  };
}

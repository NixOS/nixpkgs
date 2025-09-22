{
  lib,
  stdenv,
  fetchFromGitea,
  makeWrapper,
  bash,

  git,
  nix-prefetch-git,
  rWrapper,
  rPackages,

  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "git-unroll";
  version = "0-unstable-2025-08-14";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "gm6k";
    repo = "git-unroll";
    rev = "a66aad56af0440e1d6e807518af298264861b2c7";
    hash = "sha256-Mpc2p+W8PqQ6Os9AJJJwvL00a4cjFKBUTBG5bF+IzL4=";
  };

  postPatch = ''
    substituteInPlace unroll \
      --replace-fail "#! /usr/bin/env nix-shell" "#!/usr/bin/env bash" \
      --replace-fail \
        "#! nix-shell -i bash -p git nix rWrapper rPackages.jsonlite rPackages.processx rPackages.dplyr rPackages.plyr rPackages.stringr -I nixpkgs=." \
        "" \
      --replace-fail '"$PWD/pkgs/build-support/fetchgit/nix-prefetch-git",' '"nix-prefetch-git",'
  '';

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    bash
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 unroll $out/bin/unroll
    wrapProgram $out/bin/unroll \
      --prefix PATH : ${
        lib.makeBinPath [
          git
          nix-prefetch-git
          (rWrapper.override {
            packages = with rPackages; [
              jsonlite
              processx
              dplyr
              plyr
              stringr
            ];
          })
        ]
      }

    runHook postInstall
  '';

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = {
    description = "Convert Git repositories with submodules to a Nix expression based on non-recursive Git sources";
    homepage = "https://codeberg.org/gm6k/git-unroll";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "unroll";
    platforms = lib.platforms.all;
  };
})

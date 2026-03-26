{
  lib,
  stdenv,
  fetchFromCodeberg,
  makeWrapper,
  bash,

  gitMinimal,
  nix-prefetch-git,
  rWrapper,
  rPackages,

  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "git-unroll";
  version = "0-unstable-2026-03-25";

  src = fetchFromCodeberg {
    owner = "gm6k";
    repo = "git-unroll";
    rev = "62fc6ff3fcb62b6972182d64b4f3710c2188c082";
    hash = "sha256-We3nbdZIxk27T2VXoKiwRTrBAZ2qoANpDpUXq+MgvbY=";
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
          gitMinimal
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

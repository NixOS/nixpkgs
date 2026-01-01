{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "nzp-assets";
<<<<<<< HEAD
  version = "0-unstable-2025-11-25";
=======
  version = "0-unstable-2024-09-28";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "nzp-team";
    repo = "assets";
<<<<<<< HEAD
    rev = "96dd29602d6d8af0cce9208910e7ab68bfc95019";
=======
    rev = "4a7b1b787061c1c7c17ab3b59a8e0e0f44c9546f";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    hash = "sha256-gCTC/76r0ITIDLIph9uivq0ZJGaPUmlBGizdCUxJrng=";
  };

  outputs = [
    "out"
    "pc"
  ];

  # TODO: add more outputs for other ports
  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r common/* $out

    mkdir -p $pc
    cp -r pc/* $pc
    chmod -R +w $pc/nzp
    cp -r $out/* $pc/nzp

    runHook postInstall
  '';

  meta = {
    description = "Game asset repository for Nazi Zombies: Portable";
    homepage = "https://github.com/nzp-team/assets";
    license = with lib.licenses; [ cc-by-sa-40 ];
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pluiedev ];
  };
}

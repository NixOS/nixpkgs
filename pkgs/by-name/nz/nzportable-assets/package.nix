{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "nzp-assets";
  version = "0-unstable-2024-12-01-21-00-37";

  src = fetchFromGitHub {
    owner = "nzp-team";
    repo = "assets";
    rev = "b5e1f9dad88182c95acd5bf200aa26550746be08";
    hash = "sha256-762y635sfyHRzEEbs19O2TN1t7t4XJ4BwSJTG2kcpxY=";
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

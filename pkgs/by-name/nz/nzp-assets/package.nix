{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nzportable,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "nzp-assets";
  version = "0-unstable-2024-06-05-03-35-04";

  src = fetchFromGitHub {
    owner = "nzp-team";
    repo = "assets";
    rev = "5162be1e98bc1d3efbe01916409f8abb2b1b5fdd";
    hash = "sha256-GUv5XEk5KfxjWpVkcrDI/J+/ZeWqYvchMpSnq6X34pU=";
  };

  # TODO: add more outputs for other ports
  installPhase = ''
    runHook preInstall

    mkdir -p $out/pc
    cp -r pc/* $out/pc
    chmod -R +w $out/pc/nzp
    cp -r common/* $out/pc/nzp

    runHook postInstall
  '';

  passthru.updateScript = nzportable.nzp-update {
    inherit (finalAttrs.src) owner repo;
    tag = "newest";
  };

  meta = {
    description = "Game asset repository for Nazi Zombies: Portable";
    homepage = "https://github.com/nzp-team/assets";
    # TODO license? upstream doesn't specify
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pluiedev ];
  };
})

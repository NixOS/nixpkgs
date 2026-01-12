{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rutorrent";
  version = "5.2.10";

  src = fetchFromGitHub {
    owner = "Novik";
    repo = "ruTorrent";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g1CjwK0GLAdRLWbQeyF8H+OFaL8WgibGrQti9kHz2iM=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p "$out"
    cp -r . "$out"
    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/Novik/ruTorrent/releases/tag/v${finalAttrs.version}";
    description = "Yet another web front-end for rTorrent";
    homepage = "https://github.com/Novik/ruTorrent";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
})

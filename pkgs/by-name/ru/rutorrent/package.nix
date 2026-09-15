{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rutorrent";
  version = "5.3.14";

  src = fetchFromGitHub {
    owner = "Novik";
    repo = "ruTorrent";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7ukkugwXHMSSq8jOrhmA0TMnLprNzZuHKuW40yPF2TI=";
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

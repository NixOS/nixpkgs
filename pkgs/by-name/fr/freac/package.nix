{
  lib,
  stdenv,
  fetchFromGitHub,

  boca,
  smooth,
  systemd,
  wrapGAppsHook3,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "freac";
  version = "1.1.7";

  src = fetchFromGitHub {
    owner = "enzo1982";
    repo = "freac";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-bHoRxxhSM7ipRkiBG7hEa1Iw8Z3tOHQ/atngC/3X1a4=";
  };

  buildInputs = [
    boca
    smooth
    systemd
    wrapGAppsHook3
  ];

  makeFlags = [
    "prefix=$(out)"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Audio converter and CD ripper with support for various popular formats and encoders";
    license = lib.licenses.gpl2Plus;
    homepage = "https://www.freac.org/";
    downloadPage = "https://www.freac.org/downloads-mainmenu-33";
    changelog = "https://github.com/enzo1982/freac/releases/tag/${finalAttrs.src.tag}";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ VZstless ];
    mainProgram = "freac";
  };
})

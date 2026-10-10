{
  fetchFromSourcehut,
  hareHook,
  hareThirdParty,
  himitsu,
  lib,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hiprompt-gtk";
  version = "0.10";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hiprompt-gtk";
    rev = finalAttrs.version;
    hash = "sha256-YNOI3uhQtdXX90k5gmpT7vwC49AOuTt/ae6mHjO2Bgw=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    hareHook
    pkg-config
    himitsu
    hareThirdParty.hare-gi
    hareThirdParty.hare-adwaita
    hareThirdParty.hare-gtk4-layer-shell
  ];
  buildInputs = [
    # needed to get the propagatedBuildInputs
    hareThirdParty.hare-gi
    hareThirdParty.hare-adwaita
    hareThirdParty.hare-gtk4-layer-shell
  ];

  installFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    homepage = "https://git.sr.ht/~sircmpwn/hiprompt-gtk";
    description = "GTK4 prompter for Himitsu";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ oliverpool ];
    inherit (hareHook.meta) platforms badPlatforms;
    mainProgram = "hiprompt-gtk";
  };
})

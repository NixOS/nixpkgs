{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  xdg-utils,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "morewaita-icon-theme";
  version = "48.1";

  src = fetchFromGitHub {
    owner = "somepaulo";
    repo = "MoreWaita";
    tag = "v${finalAttrs.version}";
    hash = "sha256-18jI4hADVHC/WCmMTlA+VBuZ1jNGSxL+lO3GwWDiNoU=";
  };

  nativeBuildInputs = [
    gtk3
    xdg-utils
  ];

  installPhase = ''
    runHook preInstall

    install -d $out/share/icons/MoreWaita
    cp -r . $out/share/icons/MoreWaita
    gtk-update-icon-cache -f -t $out/share/icons/MoreWaita && xdg-desktop-menu forceupdate

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Adwaita style extra icons theme for Gnome Shell";
    homepage = "https://github.com/somepaulo/MoreWaita";
    license = with lib.licenses; [ gpl3Only ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pkosel ];
  };
})

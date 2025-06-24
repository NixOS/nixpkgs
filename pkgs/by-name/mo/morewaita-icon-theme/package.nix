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

  postPatch = ''
    patchShebangs install.sh

    # Replace this workaround if https://github.com/somepaulo/MoreWaita/pull/339 is merged
    substituteInPlace install.sh \
      --replace-fail '"''${HOME}/.local/share/' '"$out/share/'
  '';

  nativeBuildInputs = [
    gtk3
    xdg-utils
  ];

  installPhase = ''
    runHook preInstall

    ./install.sh

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
    maintainers = with lib.maintainers; [
      pkosel
      kachick
    ];
  };
})

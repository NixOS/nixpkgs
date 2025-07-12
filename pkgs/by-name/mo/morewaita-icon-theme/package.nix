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
  version = "48.3";

  src = fetchFromGitHub {
    owner = "somepaulo";
    repo = "MoreWaita";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ywZSRNXVxjs5l5UO4yvNZ7q7PRlaLNi/2+HSNhe8e5w=";
  };

  postPatch = ''
    patchShebangs install.sh
  '';

  nativeBuildInputs = [
    gtk3
    xdg-utils
  ];

  installPhase = ''
    runHook preInstall

    THEMEDIR="$out/share/icons/MoreWaita" ./install.sh

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

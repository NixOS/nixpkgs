{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  adwaita-icon-theme,
  gtk3,
  xdg-utils,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "morewaita-icon-theme";
  version = "50";

  src = fetchFromGitHub {
    owner = "somepaulo";
    repo = "MoreWaita";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5r96hVL6ozfiNFYWnZiMbz19rW7M84yntrDu10Yyc9U=";
  };

  postPatch = ''
    patchShebangs install.sh
  '';

  nativeBuildInputs = [
    gtk3
    xdg-utils
  ];

  propagatedBuildInputs = [
    adwaita-icon-theme
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
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      pkosel
    ];
  };
})

{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  kdePackages,
  papirus-icon-theme,
  adwaita-icon-theme,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "delta-icon-theme";
  version = "2026.08.09+27029645";

  strictDeps = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Delta-Icons";
    repo = "linux";
    tag = finalAttrs.version;
    hash = "sha256-NyyKWd8oY29J4PKQpF8fiFZKYLCB8WjrzX5p42UT+3A=";
  };

  propagatedBuildInputs = [
    kdePackages.breeze-icons
    adwaita-icon-theme
    papirus-icon-theme
  ];

  # breeze-icons propagates qtbase
  dontWrapQtApps = true;

  dontDropIconThemeCache = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    mv Delta* $out/share/icons

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    # taken from the homepage (chopped to avoid referencing "Delta" itself)
    description = "An open source icon pack made by awesome people";
    homepage = "https://delta-icons.github.io";
    # stated in the readme
    license = lib.licenses.cc-by-nd-40;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      hashcube
    ];
  };
})

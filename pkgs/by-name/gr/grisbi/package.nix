{
  fetchFromGitHub,
  lib,
  stdenv,
  gtk3,
  pkg-config,
  libgsf,
  libofx,
  autoreconfHook,
  intltool,
  wrapGAppsHook3,
  adwaita-icon-theme,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "grisbi";
  version = "3.0.4";

  src = fetchFromGitHub {
    owner = "grisbi";
    repo = "grisbi";
    tag = "upstream_version_${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-3E57M/XE4xyo3ppVceDA4OFDnVicosCY8ikE2gDJoUQ=";
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
    intltool
    autoreconfHook
  ];

  buildInputs = [
    gtk3
    libgsf
    libofx
    adwaita-icon-theme
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Personnal accounting application";
    mainProgram = "grisbi";
    longDescription = ''
      Grisbi is an application written by French developers, so it perfectly
      respects French accounting rules. Grisbi can manage multiple accounts,
      currencies and users. It manages third party, expenditure and receipt
      categories, budgetary lines, financial years, budget estimates, bankcard
      management and other information that make Grisbi adapted for
      associations.
    '';
    homepage = "https://grisbi.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ layus ];
    platforms = platforms.linux;
  };
})

{ lib
, python3
, fetchFromGitHub
, appstream-glib
, desktop-file-utils
, gettext
, gobject-introspection
, gtk3
, gtk4
, libadwaita
, meson
, ninja
, pkg-config
, wrapGAppsHook4
, nix-update-script
}:

python3.pkgs.buildPythonApplication rec {
  pname = "portfolio";
  version = "1.0.1";

  format = "other";

  src = fetchFromGitHub {
    owner = "tchx84";
    repo = "Portfolio";
    rev = "v${version}";
    hash = "sha256-IbzAkHlD6duXkPJRSyD9HJ/JHP8+IR7vIGFp2ESbBug=";
  };

  postPatch = ''
    patchShebangs build-aux/meson
  '';

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    gettext
    gobject-introspection
    gtk3 # For gtk-update-icon-cache
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
  ];

  checkPhase = ''
    meson test
  '';

  postInstall = ''
    ln -s dev.tchx84.Portfolio "$out/bin/portfolio"
  '';

  # Prevent double wrapping
  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Minimalist file manager for those who want to use Linux mobile devices";
    homepage = "https://github.com/tchx84/Portfolio";
    changelog = "https://github.com/tchx84/Portfolio/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    mainProgram = "dev.tchx84.Portfolio";
    maintainers = with maintainers; [ dotlambda chuangzhu ];
  };
}

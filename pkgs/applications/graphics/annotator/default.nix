{
  stdenv,
  lib,
  fetchFromGitHub,
  nix-update-script,
  vala,
  meson,
  ninja,
  pkg-config,
  pantheon,
  gettext,
  wrapGAppsHook,
  python3,
  shared-mime-info,
  gtk3,
  glib,
  libgee,
  libhandy,
  libxml2,
}:

stdenv.mkDerivation rec {
  pname = "Annotator";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "phase1geo";
    repo = pname;
    rev = version;
    sha256 = "zJRnr0Gb4GGfMKExvu6pvMNmM1VVO7brl3bcCU+ldqY=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    gettext
    wrapGAppsHook
    python3
    glib # for glib-compile-schemas
    shared-mime-info # for update-mime-database
  ];

  buildInputs = [
    gtk3
    glib
    pantheon.granite
    libhandy
    libgee
    libxml2
  ];

  postPatch = ''
    patchShebangs meson/post_install.py

    # https://github.com/phase1geo/Annotator/pull/20
    substituteInPlace data/com.github.phase1geo.annotator.gresource.xml \
      --replace "sticker_images/icons8_cup" "sticker_icons8_cup"
  '';

  postInstall = ''
    # These icons are not defined in icon-naming-spec so they are not widely available.
    # Let’s include those from Pantheon as a fallback.
    nonStandardIcons=(
      actions/24/document-export.svg
      actions/24/format-text-highlight.svg
      actions/symbolic/image-crop-symbolic.svg
    )
    for icon in "''${nonStandardIcons[@]}"; do
      # elementary has a different layout from hicolor icon theme.
      targetIcon=$(echo "$icon" | sed -E "s#^actions/24/#24x24/actions/#;s#^actions/symbolic/#16x16/actions/#")
      mkdir -p "$(dirname "$out/share/icons/hicolor/$targetIcon")"
      ln -s "${pantheon.elementary-icon-theme}/share/icons/elementary/$icon" "$out/share/icons/hicolor/$targetIcon"
    done
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with lib; {
    description = "Image annotation for Elementary OS";
    homepage = "https://github.com/phase1geo/Annotator";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}

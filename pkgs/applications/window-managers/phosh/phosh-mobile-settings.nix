{ lib
, stdenv
, fetchFromGitLab
, gitUpdater
, meson
, ninja
, pkg-config
, wrapGAppsHook
, desktop-file-utils
, feedbackd
, gtk4
, libadwaita
, lm_sensors
, phoc
, phosh
, wayland-protocols
}:

stdenv.mkDerivation rec {
  pname = "phosh-mobile-settings";
  version = "0.23.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "guidog";
    repo = "phosh-mobile-settings";
    rev = "v${version}";
    sha256 = "sha256-D605efn25Dl3Bj92DZiagcx+MMcRz0GRaWxplBRcZhA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    phosh
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    desktop-file-utils
    feedbackd
    gtk4
    libadwaita
    lm_sensors
    phoc
    wayland-protocols
  ];

  postInstall = ''
    # this is optional, but without it phosh-mobile-settings won't know about lock screen plugins
    ln -s '${phosh}/lib/phosh' "$out/lib/phosh"

    # .desktop files marked `OnlyShowIn=Phosh;` aren't displayed even in our phosh, so remove that.
    # also make the Exec path absolute.
    substituteInPlace "$out/share/applications/org.sigxcpu.MobileSettings.desktop" \
      --replace 'OnlyShowIn=Phosh;' "" \
      --replace 'Exec=phosh-mobile-settings' "Exec=$out/bin/phosh-mobile-settings"
  '';

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "A settings app for mobile specific things";
    homepage = "https://gitlab.gnome.org/guidog/phosh-mobile-settings";
    changelog = "https://gitlab.gnome.org/guidog/phosh-mobile-settings/-/blob/v${version}/debian/changelog";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ colinsane ];
    platforms = platforms.linux;
  };
}

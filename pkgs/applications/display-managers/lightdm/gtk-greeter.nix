{ stdenv
, lib
, lightdm-gtk-greeter
, fetchurl
, lightdm
, pkg-config
, intltool
, linkFarm
, wrapGAppsHook3
, gtk3
, xfce4-dev-tools
, at-spi2-core
, librsvg
, hicolor-icon-theme
}:

stdenv.mkDerivation rec {
  pname = "lightdm-gtk-greeter";
  version = "2.0.9";

  src = fetchurl {
    # Release tarball differs from source tarball.
    url = "https://github.com/Xubuntu/lightdm-gtk-greeter/releases/download/lightdm-gtk-greeter-${version}/lightdm-gtk-greeter-${version}.tar.gz";
    hash = "sha256-yP3xmKqaP50NrQtI3+I8Ine3kQfo/PxillKQ8QgfZF0=";
  };

  nativeBuildInputs = [
    pkg-config
    intltool
    xfce4-dev-tools
    wrapGAppsHook3
  ];

  buildInputs = [
    lightdm
    librsvg
    hicolor-icon-theme
    gtk3
  ];

  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--disable-indicator-services-command"
    "--sbindir=${placeholder "out"}/bin" # for wrapGAppsHook3 to wrap automatically
  ];

  preConfigure = ''
    configureFlagsArray+=( --enable-at-spi-command="${at-spi2-core}/libexec/at-spi-bus-launcher --launch-immediately" )
  '';

  installFlags = [
    "localstatedir=\${TMPDIR}"
    "sysconfdir=${placeholder "out"}/etc"
  ];

  postInstall = ''
    substituteInPlace "$out/share/xgreeters/lightdm-gtk-greeter.desktop" \
      --replace-fail "Exec=lightdm-gtk-greeter" "Exec=$out/bin/lightdm-gtk-greeter"
  '';

  passthru.xgreeters = linkFarm "lightdm-gtk-greeter-xgreeters" [{
    path = "${lightdm-gtk-greeter}/share/xgreeters/lightdm-gtk-greeter.desktop";
    name = "lightdm-gtk-greeter.desktop";
  }];

  meta = with lib; {
    homepage = "https://github.com/Xubuntu/lightdm-gtk-greeter";
    description = "GTK greeter for LightDM";
    mainProgram = "lightdm-gtk-greeter";
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ bobby285271 ];
  };
}

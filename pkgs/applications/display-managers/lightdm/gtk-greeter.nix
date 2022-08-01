{ stdenv
, lib
, lightdm-gtk-greeter
, fetchurl
, lightdm
, pkg-config
, intltool
, linkFarm
, wrapGAppsHook
, gtk3
, xfce4-dev-tools
, at-spi2-core
, librsvg
, hicolor-icon-theme
}:

stdenv.mkDerivation rec {
  pname = "lightdm-gtk-greeter";
  version = "2.0.7";

  src = fetchurl {
    # Release tarball differs from source tarball.
    url = "https://github.com/Xubuntu/lightdm-gtk-greeter/releases/download/lightdm-gtk-greeter-${version}/lightdm-gtk-greeter-${version}.tar.gz";
    sha256 = "1g7wc3d3vqfa7mrdhx1w9ywydgjbffla6rbrxq9k3sc62br97qms";
  };

  nativeBuildInputs = [
    pkg-config
    intltool
    xfce4-dev-tools
    wrapGAppsHook
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
    "--sbindir=${placeholder "out"}/bin" # for wrapGAppsHook to wrap automatically
  ];

  postPatch = ''
    # exo-csource has been dropped from exo, and replaced by xdt-csource from xfce4-dev-tools
    for f in configure.ac src/Makefile.am; do
      substituteInPlace $f --replace exo-csource xdt-csource
    done
  '';

  preConfigure = ''
    configureFlagsArray+=( --enable-at-spi-command="${at-spi2-core}/libexec/at-spi-bus-launcher --launch-immediately" )
  '';

  NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  installFlags = [
    "localstatedir=\${TMPDIR}"
    "sysconfdir=${placeholder "out"}/etc"
  ];

  postInstall = ''
    substituteInPlace "$out/share/xgreeters/lightdm-gtk-greeter.desktop" \
      --replace "Exec=lightdm-gtk-greeter" "Exec=$out/bin/lightdm-gtk-greeter"
  '';

  passthru.xgreeters = linkFarm "lightdm-gtk-greeter-xgreeters" [{
    path = "${lightdm-gtk-greeter}/share/xgreeters/lightdm-gtk-greeter.desktop";
    name = "lightdm-gtk-greeter.desktop";
  }];

  meta = with lib; {
    homepage = "https://github.com/Xubuntu/lightdm-gtk-greeter";
    description = "A GTK greeter for LightDM";
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ bobby285271 ];
  };
}

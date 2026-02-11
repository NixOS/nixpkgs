{
  lib,
  stdenv,
  fetchFromGitHub,
  gnome-shell,
  glib,
  libxml2,
  gtk-engine-murrine,
  gdk-pixbuf,
  librsvg,
  bc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "equilux-theme";
  version = "20181029";

  src = fetchFromGitHub {
    owner = "ddnexus";
    repo = "equilux-theme";
    tag = "equilux-v${finalAttrs.version}";
    hash = "sha256-zCEo2D6/PH0MBbb8ssg415EWA1iWm1Nu59NWC7v3YlM=";
  };

  nativeBuildInputs = [
    glib
    libxml2
    bc
  ];

  buildInputs = [
    gdk-pixbuf
    librsvg
  ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  dontBuild = true;

  installPhase = ''
    patchShebangs install.sh
    sed -i install.sh \
      -e "s|if .*which gnome-shell.*;|if true;|" \
      -e "s|CURRENT_GS_VERSION=.*$|CURRENT_GS_VERSION=${lib.versions.majorMinor gnome-shell.version}|"
    mkdir -p $out/share/themes
    ./install.sh --dest $out/share/themes
    rm $out/share/themes/*/COPYING
  '';

  meta = {
    inherit (finalAttrs.src.meta) homepage;
    description = "Material Design theme for GNOME/GTK based desktop environments";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.fpletz ];
  };
})

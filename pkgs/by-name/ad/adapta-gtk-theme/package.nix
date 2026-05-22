{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  parallel,
  sassc,
  inkscape,
  libxml2,
  glib,
  gdk-pixbuf,
  librsvg,
  gtk-engine-murrine,
  gnome-shell,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "adapta-gtk-theme";
  version = "3.95.0.11";

  src = fetchFromGitHub {
    owner = "adapta-project";
    repo = "adapta-gtk-theme";
    tag = finalAttrs.version;
    hash = "sha256-BGACUGRMfbLJqjld1MqoUcidgmkjU9AWPKB3EC7MU6c=";
  };

  preferLocalBuild = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    parallel
    sassc
    inkscape
    libxml2
    glib.dev
    gnome-shell
  ];

  buildInputs = [
    gdk-pixbuf
    librsvg
  ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  postPatch = "patchShebangs .";

  configureFlags = [
    "--disable-gtk_legacy"
    "--disable-gtk_next"
    "--disable-unity"
  ];

  meta = {
    description = "Adaptive GTK theme based on Material Design Guidelines";
    homepage = "https://github.com/adapta-project/adapta-gtk-theme";
    license = with lib.licenses; [
      gpl2
      cc-by-sa-30
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ romildo ];
  };
})

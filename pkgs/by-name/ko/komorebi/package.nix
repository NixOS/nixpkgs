{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  vala,
  pkg-config,
  glib,
  gtk3,
  libgee,
  webkitgtk_4_1,
  clutter-gtk,
  clutter-gst,
  ninja,
  wrapGAppsHook3,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "komorebi";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "Komorebi-Fork";
    repo = "komorebi";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vER69dSxu4JuWNAADpkxHE/zjOMhQp+Fc21J+JHQ8xk=";
  };

  nativeBuildInputs = [
    meson
    vala
    pkg-config
    ninja
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    libgee
    webkitgtk_4_1
    clutter-gtk
    clutter-gst
  ];

  postPatch = ''
    substituteInPlace meson.build --replace-fail "webkit2gtk-4.0" "webkit2gtk-4.1"
  '';
  passthru.tests.version = testers.testVersion { package = finalAttrs.finalPackage; };

  meta = {
    description = "Beautiful and customizable wallpaper manager for Linux";
    homepage = "https://github.com/Komorebi-Fork/komorebi";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})

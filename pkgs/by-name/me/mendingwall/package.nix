{
  lib,
  stdenv,
  fetchFromGitHub,
  wrapGAppsHook4,
  meson,
  blueprint-compiler,
  glib,
  gtk4,
  libadwaita,
  gettext,
  appstream,
  desktop-file-utils,
  pkg-config,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mendingwall";
  version = "0.3.9";

  src = fetchFromGitHub {
    owner = "lawmurray";
    repo = "mendingwall";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+p5fpop22zHmKZxoZBjTET2p+X/ulQyMMnZxiPLkZC0=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    meson
    blueprint-compiler
    gettext
    appstream
    desktop-file-utils
    pkg-config
    ninja
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
  ];

  meta = with lib; {
    description = "Fix theme and menu inconsistencies when using multiple desktop environments";
    homepage = "https://mendingwall.indii.org/";
    changelog = "https://github.com/lawmurray/mendingwall/releases/tag/v${finalAttrs.version}";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.jromer ];
    platforms = platforms.linux;
    mainProgram = "mendingwall";
  };
})

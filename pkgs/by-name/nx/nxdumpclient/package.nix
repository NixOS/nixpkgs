{
  lib,
  stdenv,
  fetchFromGitHub,
  vala,
  meson,
  ninja,
  pkg-config,
  desktop-file-utils,
  gusb,
  gtk4,
  glib,
  wrapGAppsHook4,
  blueprint-compiler,
  libadwaita,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "nxdumpclient";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "v1993";
    repo = "nxdumpclient";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6jekESpsV6sDhBh23D7d5/BlGWI1G5SYgWudNvQKzqc=";
  };

  nativeBuildInputs = [
    vala
    meson
    ninja
    pkg-config
    desktop-file-utils
    wrapGAppsHook4
    blueprint-compiler
  ];

  buildInputs = [
    gtk4
    glib
    gusb
    libadwaita
  ];

  mesonFlags = [
    (lib.mesonEnable "libportal" false)
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A client program for dumping over USB with nxdumptool";
    homepage = "https://github.com/v1993/nxdumpclient";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ranidspace ];
    mainProgram = "nxdumpclient";
    platforms = lib.platforms.linux;
  };
})

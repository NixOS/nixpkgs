{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  nix-update-script,
  modemmanager,
  glib,
  libqmi,
  qrtr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "81voltd";
  version = "1.2.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitLab {
    domain = "gitlab.postmarketos.org";
    owner = "modem";
    repo = "81voltd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4Pezn0nuaN5HRyh9WrazS6lKpX3SyAfZcPdck21st7I=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    modemmanager
    glib
    libqmi
    qrtr
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Server-side implementation of the QMI IMS Data service";
    homepage = "https://gitlab.postmarketos.org/modem/81voltd";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    mainProgram = "81voltd";
    platforms = lib.platforms.linux;
  };
})

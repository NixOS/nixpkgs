{
  lib,
  stdenv,
  fetchFromGitLab,
  gnugrep,
  meson,
  ninja,
  pkg-config,
  scdoc,
  curl,
  glib,
  libgpiod,
  libgudev,
  libusb1,
  modemmanager,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "eg25-manager";
  version = "0.5.2";

  src = fetchFromGitLab {
    owner = "mobian1";
    repo = "eg25-manager";
    rev = finalAttrs.version;
    hash = "sha256-Zna+JplmYrxPYsXToJ3vKOPzPMZYB3bEdfT8GIAHATs=";
  };

  postPatch = ''
    substituteInPlace 'udev/80-modem-eg25.rules' \
      --replace-fail '/bin/grep' '${lib.getExe gnugrep}'
  '';

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    glib # Contains gdbus-codegen program
    meson
    ninja
    pkg-config
    scdoc
  ];

  buildInputs = [
    curl
    glib
    libgpiod
    libgudev
    libusb1
    modemmanager
  ];

  strictDeps = true;
  doInstallCheck = true;

  meta = {
    description = "Manager daemon for the Quectel EG25 mobile broadband modem found on the Pine64 PinePhone and PinePhone Pro";
    homepage = "https://gitlab.com/mobian1/eg25-manager";
    changelog = "https://gitlab.com/mobian1/eg25-manager/-/tags/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    mainProgram = "eg25-manager";
    maintainers = with lib.maintainers; [ Luflosi ];
    platforms = lib.platforms.linux;
  };
})

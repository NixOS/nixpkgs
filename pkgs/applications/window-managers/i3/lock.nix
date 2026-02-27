{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  libxcb,
  libxcb-keysyms,
  libxcb-image,
  xcbutilxrm,
  pam,
  libx11,
  libev,
  cairo,
  libxkbcommon,
  libxkbfile,
  libxcb-util,
}:

stdenv.mkDerivation rec {
  pname = "i3lock";
  version = "2.15";

  src = fetchFromGitHub {
    owner = "i3";
    repo = "i3lock";
    rev = version;
    sha256 = "sha256-OyV6GSLnNV3GUqrfs3OBnIaBvicH2PXgeY4acOk5dR4=";
  };

  separateDebugInfo = true;
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [
    libxcb
    libxcb-keysyms
    libxcb-image
    xcbutilxrm
    pam
    libx11
    libev
    cairo
    libxkbcommon
    libxkbfile
    libxcb-util
  ];

  meta = {
    description = "Simple screen locker like slock";
    longDescription = ''
      Simple screen locker. After locking, a colored background (default: white) or
      a configurable image is shown, and a ring-shaped unlock-indicator gives feedback
      for every keystroke. After entering your password, the screen is unlocked again.
    '';
    homepage = "https://i3wm.org/i3lock/";
    maintainers = with lib.maintainers; [
      malyn
    ];
    mainProgram = "i3lock";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
  };

}

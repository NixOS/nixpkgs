{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  hidapi,
  udevCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "headsetcontrol";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "Sapd";
    repo = "HeadsetControl";
    rev = finalAttrs.version;
    sha256 = "sha256-3mwX6XqoW5wphBHEqDQ1LMCSCv+3OtNlE9cz4M437ME=";
  };

  nativeBuildInputs = [
    cmake
    udevCheckHook
  ];

  buildInputs = [
    hidapi
  ];

  doInstallCheck = true;

  meta = {
    description = "Sidetone and Battery status for Logitech G930, G533, G633, G933 SteelSeries Arctis 7/PRO 2019 and Corsair VOID (Pro)";
    longDescription = ''
      A tool to control certain aspects of USB-connected headsets on Linux. Currently,
      support is provided for adjusting sidetone, getting battery state, controlling
      LEDs, and setting the inactive time.
    '';
    homepage = "https://github.com/Sapd/HeadsetControl";
    license = lib.licenses.gpl3Plus;
    mainProgram = "headsetcontrol";
    maintainers = with lib.maintainers; [ leixb ];
    platforms = lib.platforms.all;
  };
})

{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  hidapi,
  udevCheckHook,
}:

stdenv.mkDerivation rec {
  pname = "headsetcontrol";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "Sapd";
    repo = "HeadsetControl";
    rev = version;
    sha256 = "sha256-9LUqYV0MMTtlFYZCEn81kML5F46GDYWYwoKpO0UORcQ=";
  };

  nativeBuildInputs = [
    cmake
    udevCheckHook
  ];

  buildInputs = [
    hidapi
  ];

  doInstallCheck = true;

  meta = with lib; {
    description = "Sidetone and Battery status for Logitech G930, G533, G633, G933 SteelSeries Arctis 7/PRO 2019 and Corsair VOID (Pro)";
    longDescription = ''
      A tool to control certain aspects of USB-connected headsets on Linux. Currently,
      support is provided for adjusting sidetone, getting battery state, controlling
      LEDs, and setting the inactive time.
    '';
    homepage = "https://github.com/Sapd/HeadsetControl";
    license = licenses.gpl3Plus;
    mainProgram = "headsetcontrol";
    maintainers = with maintainers; [ leixb ];
    platforms = platforms.all;
  };
}

{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  hidapi,
}:

stdenv.mkDerivation rec {
  pname = "headsetcontrol";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "Sapd";
    repo = "HeadsetControl";
    rev = version;
    sha256 = "sha256-N1c94iAJgCPhGNDCGjMINg0AL2wPX5gVIsJ+pzn/l9Y=";
  };

  patches = [
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/Sapd/HeadsetControl/pull/337.patch";
      hash = "sha256-18w9BQsMljEA/eY3rnosHvKwhiaF79TrWH/ayuyZMrM=";
    })
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    hidapi
  ];

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

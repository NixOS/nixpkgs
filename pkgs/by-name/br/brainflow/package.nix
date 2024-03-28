{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "brainflow";
  version = "5.11.0";

  src = fetchFromGitHub {
    owner = "brainflow-dev";
    repo = "brainflow";
    rev = version;
    hash = "sha256-mV/8mEAMsc1VyFmNinX4KUHswuspZL0l0iZCGULdXB8=";
  };

  nativeBuildInputs = [ cmake ];

  postPatch = ''
    for file in \
      "cpp_package/build.cmake" \
      "src/ml/build.cmake" \
      "src/board_controller/openbci/ganglion_bglib/build.cmake" \
      "src/utils/bluetooth/build.cmake" \
      "src/board_controller/build.cmake" \
      "src/board_controller/neuromd/brainbit_bglib/build.cmake" \
      "src/board_controller/muse/muse_bglib/build.cmake" \
      "src/data_handler/build.cmake"; do
        substituteInPlace "$file" \
          --replace-fail "DESTINATION inc" "DESTINATION include"
    done
  '';

  meta = with lib; {
    description = "Obtain, parse and analyze EEG, EMG, ECG and other kinds of data from biosensors";
    homepage = "https://brainflow.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ ziguana ];
    platforms = platforms.linux;
  };
}

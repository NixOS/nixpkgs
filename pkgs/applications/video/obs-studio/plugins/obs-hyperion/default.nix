{ stdenv, lib, fetchFromGitHub, cmake, flatbuffers, git, obs-studio, qtbase }:

stdenv.mkDerivation rec {
  pname = "obs-hyperion";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "hyperion-project";
    repo = "hyperion-obs-plugin";
    rev = version;
    sha256 = "sha256-pfWfJWuIoa+74u5J76/GE+OuHkksbwOAPfsR9OGX3L4=";
  };

  nativeBuildInputs = [ cmake flatbuffers git ];
  buildInputs = [ obs-studio qtbase flatbuffers git ];

  cmakeFlags = [
    "-DOBS_SOURCE=${obs-studio.src}"
    "-DFLATBUFFERS_FLATC_EXECUTABLE=${flatbuffers}/bin/flatc"
    "-DGLOBAL_INSTALLATION=ON"
  ];

  dontWrapQtApps = true;

  meta = with lib; {
    description = "OBS Studio plugin to connect to a Hyperion.ng server";
    license = licenses.mit;
    maintainers = with maintainers; [ algram ];
    platforms = [ "x86_64-linux" ];
  };
}

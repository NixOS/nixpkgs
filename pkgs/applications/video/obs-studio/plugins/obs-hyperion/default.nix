{ stdenv, lib, fetchFromGitHub, cmake, pkg-config, obs-studio, libGL
, qtbase, flatbuffers }:

stdenv.mkDerivation rec {
  pname = "obs-hyperion";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "hyperion-project";
    repo = "hyperion-obs-plugin";
    rev = version;
    sha256 = "sha256-pfWfJWuIoa+74u5J76/GE+OuHkksbwOAPfsR9OGX3L4=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ obs-studio libGL qtbase ];

  dontWrapQtApps = true;

  cmakeFlags = [
    "-DOBS_SOURCE=${obs-studio.src}"
    "-DGLOBAL_INSTALLATION=ON"
  ];

  preConfigure = ''
    # https://github.com/hyperion-project/hyperion-obs-plugin/issues/7
    rm -rf external/flatbuffers
    cp -r ${flatbuffers.src} external/flatbuffers
    chmod -R a+w external
  '';

  meta = with lib; {
    description = "OBS Studio plugin to connect to a Hyperion.ng server";
    homepage = "https://github.com/hyperion-project/hyperion-obs-plugin";
    license = licenses.mit;
    maintainers = with maintainers; [ algram ];
    platforms = [ "x86_64-linux" ];
  };
}

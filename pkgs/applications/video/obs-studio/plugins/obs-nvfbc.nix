{ stdenv, lib, fetchFromGitLab, meson, ninja, pkg-config
, obs-studio, libGL, libX11
}:

stdenv.mkDerivation rec {
  pname = "obs-nvfbc";
  version = "0.0.3";

  src = fetchFromGitLab {
    owner = "fzwoch";
    repo = "obs-nvfbc";
    rev = "v${version}";
    sha256 = "0zyvks6gc6fr0a1j5b4y20rcx6ah35v6yiz05f6g3x6bhqi92l33";
  };

  nativeBuildInputs = [ meson pkg-config ninja ];
  buildInputs = [ obs-studio libGL libX11 ];

  meta = with lib; {
    description = "OBS Studio source plugin for NVIDIA FBC API";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ babbaj ];
    platforms = [ "x86_64-linux" ];
  };
}

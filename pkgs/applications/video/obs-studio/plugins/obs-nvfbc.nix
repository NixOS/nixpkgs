{ stdenv, lib, fetchFromGitLab, meson, ninja, pkg-config
, obs-studio, libGL, libX11
}:

stdenv.mkDerivation rec {
  pname = "obs-nvfbc";
  version = "0.0.6";

  src = fetchFromGitLab {
    owner = "fzwoch";
    repo = "obs-nvfbc";
    rev = "v${version}";
    sha256 = "sha256-WoqtppgIcjE0n9atsvAZrXvBVi2rWCIIFDXTgblQK9I=";
  };

  nativeBuildInputs = [ meson pkg-config ninja ];
  buildInputs = [ obs-studio libGL libX11 ];

  meta = with lib; {
    description = "OBS Studio source plugin for NVIDIA FBC API";
    homepage = "https://gitlab.com/fzwoch/obs-nvfbc";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ babbaj ];
    platforms = [ "x86_64-linux" ];
  };
}

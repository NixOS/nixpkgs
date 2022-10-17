{ stdenv, lib, fetchFromGitLab, meson, ninja, pkg-config, obs-studio, libGL
, qtbase }:

stdenv.mkDerivation rec {
  pname = "obs-hyperion";
  version = "1.0.1";

  src = fetchFromGitLab {
    owner = "hyperion-project";
    repo = "hyperion-obs-plugin";
    rev = "v${version}";
    sha256 = "sha256-Si+TGYWpNPtUUFT+M571lCYslPyeYX92MdYV2EGgcyQ=";
  };

  nativeBuildInputs = [ meson pkg-config ninja ];
  buildInputs = [ obs-studio libGL qtbase ];

  meta = with lib; {
    description = "OBS Studio plugin to connect to a Hyperion.ng server";
    license = licenses.mit;
    maintainers = with maintainers; [ algram ];
    platforms = [ "x86_64-linux" ];
  };
}

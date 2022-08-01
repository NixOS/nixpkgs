{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
, wayland
, obs-studio
, libX11
, vulkan-headers
, vulkan-loader
, libGL
}:

stdenv.mkDerivation rec {
  pname = "obs-vkcapture";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "nowrep";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-eZbZBff/M0S9VASiKoGJAqZ6NMADH7uH8J0m6XGY3jY=";
  };

  nativeBuildInputs = [ cmake ninja ];
  buildInputs = [ libGL libX11 obs-studio vulkan-headers vulkan-loader wayland ];

  meta = with lib; {
    description = "OBS Linux Vulkan/OpenGL game capture";
    homepage = "https://github.com/nowrep/obs-vkcapture";
    maintainers = with maintainers; [ atila ];
    license = licenses.gpl2Only;
    platforms = platforms.linux;
  };
}

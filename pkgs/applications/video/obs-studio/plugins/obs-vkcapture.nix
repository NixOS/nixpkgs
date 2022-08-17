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
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "nowrep";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-TNXoeNktMde7GfFhZRHXlARdnkJTY4oNZTKA4hu7e3Q=";
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

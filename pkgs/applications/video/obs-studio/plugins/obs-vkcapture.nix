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
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "nowrep";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-iIV9ke2yPEt2Lf4bwiEHFip4tLhMS4raWGyCWpao74w=";
  };

  nativeBuildInputs = [ cmake ninja ];
  buildInputs = [ libGL libX11 obs-studio vulkan-headers vulkan-loader wayland ];

  meta = with lib; {
    description = "OBS Linux Vulkan/OpenGL game capture";
    homepage = "https://github.com/nowrep/obs-vkcapture";
    maintainers = with maintainers; [ atila ];
    license = licenses.gpl2Only;
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}

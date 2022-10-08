{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, fetchurl
, cmake
, obs-studio
}:

stdenv.mkDerivation rec {
  pname = "obs-move-transition";
  version = "2.6.4";

  src = fetchFromGitHub {
    owner = "exeldro";
    repo = "obs-move-transition";
    rev = version;
    sha256 = "sha256-+kAdCM5PEFNxKNmJmf2ASTyUKA7xnbMAA7kP/emoaeI=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio ];

  preConfigure = ''
    cp ${obs-studio.src}/cmake/external/ObsPluginHelpers.cmake cmake/
  '';

  cmakeFlags = [
    "-DBUILD_OUT_OF_TREE=On"
    "-Wno-dev"
  ];

  meta = with lib; {
    description = "Plugin for OBS Studio to move source to a new position during scene transition";
    homepage = "https://github.com/exeldro/obs-move-transition";
    maintainers = with maintainers; [ starcraft66 ];
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}

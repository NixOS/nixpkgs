{ stdenv, fetchFromGitHub
, cmake, pkgconfig, wrapQtAppsHook
, obs-studio }:

stdenv.mkDerivation {
  pname = "obs-v4l2sink-unstable";
  version = "20181012";

  src = fetchFromGitHub {
    owner = "CatxFish";
    repo = "obs-v4l2sink";
    rev = "1ec3c8ada0e1040d867ce567f177be55cd278378";
    sha256 = "03ah91cm1qz26k90mfx51l0d598i9bcmw39lkikjs1msm4c9dfxx";
  };

  nativeBuildInputs = [ cmake pkgconfig wrapQtAppsHook ];
  buildInputs = [ obs-studio ];

  patches = [
    ./0001-find-ObsPluginHelpers.cmake-in-the-obs-src.patch
  ];

  cmakeFlags = [
    "-DLIBOBS_INCLUDE_DIR=${obs-studio}/include/obs"
    "-DLIBOBS_LIBRARIES=${obs-studio}/lib"
    "-DCMAKE_CXX_FLAGS=-I${obs-studio.src}/UI/obs-frontend-api"
    "-DOBS_SRC=${obs-studio.src}"
  ];

  installPhase = ''
    mkdir -p $out/share/obs/obs-plugins/v4l2sink/bin/64bit
    cp ./v4l2sink.so $out/share/obs/obs-plugins/v4l2sink/bin/64bit/
  '';

  meta = with stdenv.lib; {
    description = "obs studio output plugin for Video4Linux2 device";
    homepage = "https://github.com/CatxFish/obs-v4l2sink";
    maintainers = with maintainers; [ colemickens ];
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" ];
  };
}

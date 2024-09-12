{ lib, stdenv, fetchFromGitHub, obs-studio, cmake, qtbase }:

stdenv.mkDerivation rec {
  pname = "obs-multi-rtmp";
  version = "0.6.0.1";

  src = fetchFromGitHub {
    owner = "sorayuki";
    repo = "obs-multi-rtmp";
    rev = version;
    sha256 = "sha256-MRBQY9m6rj8HVdn58mK/Vh07FSm0EglRUaP20P3FFO4=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio qtbase ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_QT" true)
    (lib.cmakeBool "ENABLE_FRONTEND_API" true)
    (lib.cmakeBool "CMAKE_COMPILE_WARNING_AS_ERROR" false)
  ];

  dontWrapQtApps = true;

  # install dirs changed after 0.5.0.3-OBS30
  postInstall = ''
    mkdir -p $out/{lib,share/obs/obs-plugins/}
    mv $out/dist/obs-multi-rtmp/data $out/share/obs/obs-plugins/obs-multi-rtmp
    mv $out/dist/obs-multi-rtmp/bin/64bit $out/lib/obs-plugins
    rm -rf $out/dist
  '';

  meta = with lib; {
    homepage = "https://github.com/sorayuki/obs-multi-rtmp/";
    changelog = "https://github.com/sorayuki/obs-multi-rtmp/releases/tag/${version}";
    description = "Multi-site simultaneous broadcast plugin for OBS Studio";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ jk ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}

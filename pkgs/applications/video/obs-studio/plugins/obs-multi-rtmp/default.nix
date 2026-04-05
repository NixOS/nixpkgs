{
  lib,
  stdenv,
  fetchFromGitHub,
  obs-studio,
  cmake,
  qtbase,
}:

stdenv.mkDerivation rec {
  pname = "obs-multi-rtmp";
  version = "0.7.3.2";

  src = fetchFromGitHub {
    owner = "sorayuki";
    repo = "obs-multi-rtmp";
    tag = version;
    sha256 = "sha256-edhJU06sT+pPovGcMJu4gAYbyaBKZBwSNifvXW06Ui8=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    obs-studio
    qtbase
  ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_QT" true)
    (lib.cmakeBool "ENABLE_FRONTEND_API" true)
    (lib.cmakeBool "CMAKE_COMPILE_WARNING_AS_ERROR" false)
  ];

  dontWrapQtApps = true;

  postInstall = ''
    rm -rf $out/obs-plugins $out/data
  '';

  meta = {
    homepage = "https://github.com/sorayuki/obs-multi-rtmp/";
    changelog = "https://github.com/sorayuki/obs-multi-rtmp/releases/tag/${version}";
    description = "Multi-site simultaneous broadcast plugin for OBS Studio";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ jk ];
    inherit (obs-studio.meta) platforms;
  };
}

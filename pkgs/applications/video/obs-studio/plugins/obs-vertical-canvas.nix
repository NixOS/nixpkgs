{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  curl,
  obs-studio,
  qt6,
}:

stdenv.mkDerivation rec {
  pname = "obs-vertical-canvas";
  version = "1.6.6";

  src = fetchFromGitHub {
    owner = "Aitum";
    repo = "obs-vertical-canvas";
    rev = version;
    hash = "sha256-FhO1jhD9AROEaXtEKOBPh7EfQ+Kkb4R7roGFyoqc+Ao=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    curl
    obs-studio
    qt6.qtbase
  ];

  cmakeFlags = [
    "-DBUILD_OUT_OF_TREE=On"
    ''-DCMAKE_CXX_FLAGS="-Wno-error=deprecated-declarations"''
  ];

  dontWrapQtApps = true;

  postInstall = ''
    rm -rf $out/data
    rm -rf $out/obs-plugins
  '';

  meta = {
    description = "Plugin for OBS Studio to add vertical canvas";
    homepage = "https://github.com/Aitum/obs-vertical-canvas";
    maintainers = with lib.maintainers; [
      flexiondotorg
      jonhermansen
    ];
    license = lib.licenses.gpl2Plus;
    inherit (obs-studio.meta) platforms;
  };
}

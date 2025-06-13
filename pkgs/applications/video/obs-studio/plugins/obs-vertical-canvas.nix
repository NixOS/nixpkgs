{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  curl,
  obs-studio,
  qtbase,
}:

stdenv.mkDerivation rec {
  pname = "obs-vertical-canvas";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "Aitum";
    repo = "obs-vertical-canvas";
    rev = version;
    sha256 = "sha256-rwIhmrkj+jLjSOAmFqD/hZ9/BPL5npGehSdumBoWows=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    curl
    obs-studio
    qtbase
  ];

  dontWrapQtApps = true;

  # Fix CMakeLists.txt to use new find_package syntax
  preConfigure = ''
    sed -i 's|find_qt(|find_package(Qt6 |' CMakeLists.txt
  '';

  postInstall = ''
    rm -rf $out/data $out/obs-plugins
  '';

  meta = {
    description = "Plugin for OBS Studio to add vertical canvas";
    homepage = "https://github.com/Aitum/obs-vertical-canvas";
    maintainers = with lib.maintainers; [ flexiondotorg ];
    license = lib.licenses.gpl2Plus;
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
  };
}

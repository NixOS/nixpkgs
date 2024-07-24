{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, qt6
, curl
, ffmpeg
, cubeb
}:

stdenv.mkDerivation rec {
  pname = "qcm";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "hypengw";
    repo = "Qcm";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-9xbAw5U4BtpupelsOzfZGosdLx06TKPTG8hhc/no3R0=";
  };

  patches = [ ./remove_cubeb_vendor.patch ];

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtwayland
    curl
    ffmpeg
    cubeb
  ] ++ cubeb.passthru.backendLibs;

  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath cubeb.passthru.backendLibs}"
  ];

  postInstall = ''
    rm -r $out/{include,lib/cmake}
  '';

  meta = with lib; {
    description = "Unofficial Qt client for netease cloud music";
    homepage = "https://github.com/hypengw/Qcm";
    license = licenses.gpl2Plus;
    mainProgram = "Qcm";
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.linux;
  };
}

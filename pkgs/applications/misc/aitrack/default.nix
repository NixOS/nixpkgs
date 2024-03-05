{ stdenv
, lib
, fetchFromGitHub
, pkg-config
, qmake
, wrapQtAppsHook
, opencv
, spdlog
, onnxruntime
, qtx11extras
}: stdenv.mkDerivation {
  pname = "aitrack";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "mdk97";
    repo = "aitrack-linux";
    rev = "00bcca9b685abf3a19e4eab653198ca2b1895ae4";
    sha256 = "sha256-pPvYVLUPYdjtJKdxqZI+JN7OZ4xw9gZ3baYTnJUSTGE=";
  };

  nativeBuildInputs = [
    pkg-config
    qmake
    wrapQtAppsHook
  ];

  buildInputs = [
    opencv
    spdlog
    qtx11extras
    onnxruntime
  ];

  postPatch = ''
    substituteInPlace Client/src/Main.cpp \
      --replace "/usr/share/" "$out/share/"
  '';

  postInstall = ''
    install -Dt $out/bin aitrack
    install -Dt $out/share/aitrack/models models/*
  '';

  meta = with lib; {
    description = "6DoF Head tracking software";
    maintainers = with maintainers; [ ck3d ];
    platforms = platforms.linux;
    license = licenses.mit;
  };
}

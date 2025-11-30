{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  opencv,
  spdlog,
  onnxruntime,
  libsForQt5,
  cmake,
}:
stdenv.mkDerivation {
  pname = "aitrack";
  version = "0-unstable-2024-10-17";

  src = fetchFromGitHub {
    owner = "franzitrone";
    repo = "aitrack";
    rev = "fda5d6220046fcb74b41ff7a9e826002aae09b06";
    sha256 = "sha256-LSVQwFX+rtnPz6kYFlrm9iphBOOGHaQsxjNSfUuFz3Q=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    libsForQt5.qt5.qttools
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    opencv
    spdlog
    libsForQt5.qtx11extras
    onnxruntime
  ];

  postPatch = ''
    substituteInPlace Client/src/Main.cpp \
      --replace "/usr/share/" "$out/share/"
  '';

  postBuild = ''
    cp -r ../models models
  '';

  installPhase = ''
    runHook preInstall

    install -Dt $out/bin aitrack
    install -Dt $out/share/aitrack/models models/*

    runHook postInstall
  '';

  meta = with lib; {
    description = "6DoF Head tracking software";
    mainProgram = "aitrack";
    maintainers = with maintainers; [ ck3d ];
    platforms = platforms.linux;
    license = licenses.mit;
  };
}

{ lib
, stdenv
, fetchFromGitHub
, cmake
, file
, hyprlang
, libGL
, libjpeg
, libwebp
, mesa
, pango
, pkg-config
, wayland
, wayland-protocols
, wayland-scanner
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hyprpaper";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-mqxnaNiCVJS88Dk4V1v2wdS0RaCbOk8HFOUUbp0Uiy0=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    file
    hyprlang
    libGL
    libjpeg
    libwebp
    mesa
    pango
    wayland
    wayland-protocols
  ];

  prePatch = ''
    substituteInPlace src/main.cpp \
      --replace GIT_COMMIT_HASH '"${finalAttrs.src.rev}"'
  '';

  preConfigure = ''
    make protocols
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 ./hyprpaper -t $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    inherit (finalAttrs.src.meta) homepage;
    description = "A blazing fast wayland wallpaper utility";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wozeparrot fufexan ];
    inherit (wayland.meta) platforms;
    broken = stdenv.isDarwin;
    mainProgram = "hyprpaper";
  };
})

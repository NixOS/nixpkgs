{ lib
, stdenv
, fetchFromGitHub
, cmake
, libjpeg
, mesa
, pango
, pkg-config
, wayland
, wayland-protocols
, wayland-scanner
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hyprpaper";
  version = "unstable-2022-09-30";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprpaper";
    rev = "8f4c712950ad6a9bc7c7281c15a63f5fa06ba92b";
    hash = "sha256-KojBifIOkJ2WmO/lRjQIgPgUnX5Eu10U4VDg+1MB2co=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    libjpeg
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
    maintainers = with maintainers; [ wozeparrot ];
    inherit (wayland.meta) platforms;
    # ofborg failure: g++ does not recognize '-std=c++23'
    broken = stdenv.isAarch64;
  };
})

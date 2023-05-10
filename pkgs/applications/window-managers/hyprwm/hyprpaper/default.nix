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
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-rAKfgQJQRsw4QMOXdxfHIh/d5LPY6HHKBX1KtaPs2No=";
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
    maintainers = with maintainers; [ wozeparrot fufexan ];
    inherit (wayland.meta) platforms;
    broken = stdenv.isDarwin;
  };
})

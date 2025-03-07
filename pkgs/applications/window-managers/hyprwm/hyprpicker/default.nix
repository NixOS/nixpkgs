{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, cmake
, ninja
, cairo
, fribidi
, libGL
, libdatrie
, libjpeg
, libselinux
, libsepol
, libthai
, libxkbcommon
, pango
, pcre
, util-linux
, wayland
, wayland-protocols
, wayland-scanner
, libXdmcp
, debug ? false
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "hyprpicker" + lib.optionalString debug "-debug";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprpicker";
    rev = "v${finalAttrs.version}";
    hash = "sha256-BYQF1zM6bJ44ag9FJ0aTSkhOTY9U7uRdp3SmRCs5fJM=";
  };

  cmakeBuildType = if debug then "Debug" else "Release";

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    cairo
    fribidi
    libGL
    libdatrie
    libjpeg
    libselinux
    libsepol
    libthai
    libxkbcommon
    pango
    pcre
    wayland
    wayland-protocols
    wayland-scanner
    libXdmcp
    util-linux
  ];

  postInstall = ''
    mkdir -p $out/share/licenses
    install -Dm644 $src/LICENSE -t $out/share/licenses/hyprpicker
  '';

  meta = with lib; {
    description = "Wlroots-compatible Wayland color picker that does not suck";
    homepage = "https://github.com/hyprwm/hyprpicker";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fufexan ];
    platforms = wayland.meta.platforms;
    mainProgram = "hyprpicker";
  };
})

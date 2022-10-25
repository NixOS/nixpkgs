{ lib
, stdenv
, fetchFromGitHub
, fetchFromGitLab
, cmake
, libdrm
, libinput
, libxcb
, libxkbcommon
, mesa
, pango
, pkg-config
, wayland
, wayland-protocols
, wayland-scanner
, wlroots
, xcbutilwm
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hyprland";
  version = "0.6.1beta";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "Hyprland";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0Msqe2ErAJvnO1zHoB2k6TkDhTYnHRGkvJrfSG12dTU=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    libdrm
    libinput
    libxcb
    libxkbcommon
    mesa
    pango
    wayland
    wayland-protocols
    xcbutilwm
  ]
  ++ [
    # INFO: When updating src, remember to synchronize this wlroots with the
    # exact commit used by upstream
    (wlroots.overrideAttrs (_: {
      version = "unstable-2022-06-07";
      src = fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "wlroots";
        repo = "wlroots";
        rev = "b89ed9015c3fbe8d339e9d65cf70fdca6e5645bc";
        hash = "sha256-8y3u8CoigjoZOVbA2wCWBHlDNEakv0AVxU46/cOC00s=";
      };
    }))
  ];

  # build with system wlroots
  postPatch = ''
    sed -Ei 's|"\.\./wlroots/include/([a-zA-Z0-9./_-]+)"|<\1>|g' src/includes.hpp
  '';

  preConfigure = ''
    make protocols
  '';

  postBuild = ''
    pushd ../hyprctl
    ${stdenv.cc.targetPrefix}c++ -std=c++20 -w ./main.cpp -o ./hyprctl
    popd
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 ../hyprctl/hyprctl ./Hyprland -t $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    inherit (finalAttrs.src.meta) homepage;
    description = "A dynamic tiling Wayland compositor that doesn't sacrifice on its looks";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wozeparrot ];
    inherit (wayland.meta) platforms;
    mainProgram = "Hyprland";
    # ofborg failure: g++ does not recognize '-std=c++23'
    broken = stdenv.isAarch64;
  };
})

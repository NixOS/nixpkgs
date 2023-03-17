{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, meson
, ninja
, pkg-config
, hyprland-protocols
, hyprland-share-picker
, inih
, libdrm
, mesa
, pipewire
, systemd
, wayland
, wayland-protocols
, wayland-scanner
}:
let
  source = import ./source.nix { inherit lib fetchFromGitHub wayland; };
in
stdenv.mkDerivation {
  pname = "xdg-desktop-portal-hyprland";
  inherit (source) src version meta;

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    makeWrapper
    meson
    ninja
    pkg-config
    wayland-scanner
  ];
  buildInputs = [
    hyprland-protocols
    inih
    libdrm
    mesa
    pipewire
    systemd
    wayland
    wayland-protocols
  ];

  mesonFlags = [
    "-Dsd-bus-provider=libsystemd"
  ];

  postInstall = ''
    wrapProgram $out/libexec/xdg-desktop-portal-hyprland --prefix PATH ":" ${lib.makeBinPath [hyprland-share-picker]}
  '';
}

{ stdenv
, lib
, fetchFromGitHub
, cmake
, qtbase
, makeShellWrapper
, wrapQtAppsHook
, hyprland
, grim
, slurp
, wayland
}:
let
  source = import ./source.nix { inherit lib fetchFromGitHub wayland; };
in
stdenv.mkDerivation {
  pname = "hyprland-share-picker";
  inherit (source) version;

  src = "${source.src}/hyprland-share-picker";

  nativeBuildInputs = [ cmake wrapQtAppsHook makeShellWrapper ];
  buildInputs = [ qtbase ];

  dontWrapQtApps = true;

  postInstall = ''
    wrapProgramShell $out/bin/hyprland-share-picker \
      "''${qtWrapperArgs[@]}" \
      --prefix PATH ":" ${lib.makeBinPath [grim slurp hyprland]}
  '';

  meta = source.meta // {
    description = "Helper program for xdg-desktp-portal-hyprland";
  };
}

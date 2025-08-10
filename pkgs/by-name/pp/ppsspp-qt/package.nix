{
  ppsspp,
}:

let
  argset = {
    enableQt = true;
    enableVulkan = false; # https://github.com/hrydgard/ppsspp/issues/11628
    forceWayland = false;
  };
in
ppsspp.override argset

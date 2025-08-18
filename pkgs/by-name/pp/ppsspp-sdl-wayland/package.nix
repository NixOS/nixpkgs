{
  ppsspp,
}:

let
  argset = {
    enableQt = false;
    enableVulkan = false; # https://github.com/hrydgard/ppsspp/issues/13845
    forceWayland = true;
  };
in
ppsspp.override argset

{
  ppsspp,
}:

let
  argset = {
    enableQt = false;
    enableVulkan = true;
    forceWayland = false;
  };
in
ppsspp.override argset

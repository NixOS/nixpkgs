{ runTestOn }:
{
  x11 = runTestOn [ "x86_64-linux" "aarch64-linux" ] ./x11.nix;
  wayland = runTestOn [ "x86_64-linux" "aarch64-linux" ] ./wayland.nix;
}

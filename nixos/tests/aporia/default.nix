{ handleTestOn }: {
  x11 = handleTestOn [ "x86_64-linux" "aarch64-linux" ] ./x11.nix {};
  wayland = handleTestOn [ "x86_64-linux" "aarch64-linux" ] ./wayland.nix {};
}

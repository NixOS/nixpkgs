{
  rofi-emoji,
  fetchFromGitHub,
  rofi-wayland-unwrapped,
  wl-clipboard,
  wtype,
}:

(rofi-emoji.override {
  rofi-unwrapped = rofi-wayland-unwrapped;
  xclip = wl-clipboard;
  xdotool = wtype;
}).overrideAttrs
  (
    final: _: {
      version = "4.1.0";
      src = fetchFromGitHub {
        owner = "Mange";
        repo = "rofi-emoji";
        rev = "v${final.version}";
        hash = "sha256-Amaz+83mSPue+pjZq/pJiCxu5QczYvmJk6f96eraaK8=";
      };
    }
  )

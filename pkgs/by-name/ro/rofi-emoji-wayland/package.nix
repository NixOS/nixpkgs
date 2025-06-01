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
      version = "4.0.0";
      src = fetchFromGitHub {
        owner = "Mange";
        repo = "rofi-emoji";
        rev = "v${final.version}";
        hash = "sha256-864Mohxfc3EchBKtSNifxy8g8T8YBUQ/H7+8Ti6TiFo=";
      };
    }
  )

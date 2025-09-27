{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,

  autoreconfHook,
  pkg-config,

  cairo,
  glib,
  libnotify,
  rofi-unwrapped,

  x11Support ? true,
  xclip,
  xdotool,

  waylandSupport ? true,
  wl-clipboard,
  wtype,
}:

stdenv.mkDerivation (final: {
  pname = "rofi-emoji";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "Mange";
    repo = "rofi-emoji";
    rev = "v${final.version}";
    hash = "sha256-864Mohxfc3EchBKtSNifxy8g8T8YBUQ/H7+8Ti6TiFo=";
  };

  patches = [
    # Look for plugin-related files in $out/lib/rofi
    ./0001-Patch-plugindir-to-output.patch
  ];

  postFixup = ''
    wrapProgram $out/share/rofi-emoji/clipboard-adapter.sh \
     --prefix PATH ":" ${
       lib.makeBinPath (
         [
           libnotify
         ]
         ++ lib.optionals waylandSupport [
           wl-clipboard
           wtype
         ]
         ++ lib.optionals x11Support [
           xclip
           xdotool
         ]
       )
     }
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    cairo
    glib
    rofi-unwrapped
  ];

  meta = {
    description = "Emoji selector plugin for Rofi";
    homepage = "https://github.com/Mange/rofi-emoji";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      cole-h
      Mange
    ];
    platforms = lib.platforms.linux;
  };
})

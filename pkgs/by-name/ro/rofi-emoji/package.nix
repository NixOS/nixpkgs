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
  xclip,
  xdotool,
}:

stdenv.mkDerivation (final: {
  pname = "rofi-emoji";
  version = "3.4.1";

  src = fetchFromGitHub {
    owner = "Mange";
    repo = "rofi-emoji";
    rev = "v${final.version}";
    hash = "sha256-ZHhgYytPB14zj2MS8kChRD+LTqXzHRrz7YIikuQD6i0=";
  };

  patches = [
    # Look for plugin-related files in $out/lib/rofi
    ./0001-Patch-plugindir-to-output.patch
  ];

  postPatch = ''
    patchShebangs --host clipboard-adapter.sh
  '';

  postFixup = ''
    chmod +x $out/share/rofi-emoji/clipboard-adapter.sh
    wrapProgram $out/share/rofi-emoji/clipboard-adapter.sh \
     --prefix PATH ":" ${
       lib.makeBinPath [
         libnotify
         xclip
         xdotool
       ]
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
    description = "Emoji selector plugin for Rofi (built against ${rofi-unwrapped.pname})";
    homepage = "https://github.com/Mange/rofi-emoji";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      cole-h
      Mange
    ];
    platforms = lib.platforms.linux;
  };
})

{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,

  autoreconfHook,
  pkg-config,

  waylandSupport ? true,
  x11Support ? true,

  cairo,
  glib,
  libnotify,
  rofi-unwrapped,
  wl-clipboard,
  xclip,
  xdotool,
  wtype,
}:

import ./versions.nix (
  {
    version,
    hash,
    patches,
  }:
  stdenv.mkDerivation rec {
    pname = "rofi-emoji";
    inherit version;

    src = fetchFromGitHub {
      owner = "Mange";
      repo = "rofi-emoji";
      rev = "v${version}";
      inherit hash;
    };

    inherit patches;

    postPatch = ''
      patchShebangs clipboard-adapter.sh
    '';

    postFixup = ''
      chmod +x $out/share/rofi-emoji/clipboard-adapter.sh
      wrapProgram $out/share/rofi-emoji/clipboard-adapter.sh \
       --prefix PATH ":" ${
         lib.makeBinPath (
           [ libnotify ]
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
      libnotify
      rofi-unwrapped
    ]
    ++ lib.optionals waylandSupport [
      wl-clipboard
      wtype
    ]
    ++ lib.optionals x11Support [ xclip ];

    meta = with lib; {
      description = "Emoji selector plugin for Rofi";
      homepage = "https://github.com/Mange/rofi-emoji";
      license = licenses.mit;
      maintainers = with maintainers; [
        cole-h
        Mange
      ];
      platforms = platforms.linux;
    };
  }
)

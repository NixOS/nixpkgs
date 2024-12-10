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
  xsel,
  xdotool,
  wtype,
}:

stdenv.mkDerivation rec {
  pname = "rofi-emoji";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "Mange";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Y+E5TViKFVtqXMLVEcq1VMLPzG04vfZyThUM7a/fFGM=";
  };

  patches = [
    # Look for plugin-related files in $out/lib/rofi
    ./0001-Patch-plugindir-to-output.patch
  ];

  postPatch = ''
    patchShebangs clipboard-adapter.sh
  '';

  postFixup = ''
    chmod +x $out/share/rofi-emoji/clipboard-adapter.sh
    wrapProgram $out/share/rofi-emoji/clipboard-adapter.sh \
     --prefix PATH ":" ${
       lib.makeBinPath (
         [
           libnotify
           wl-clipboard
           xclip
           xsel
         ]
         ++ lib.optionals waylandSupport [ wtype ]
         ++ lib.optionals x11Support [ xdotool ]
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
    wl-clipboard
    xclip
    xsel
  ];

  meta = with lib; {
    description = "An emoji selector plugin for Rofi";
    homepage = "https://github.com/Mange/rofi-emoji";
    license = licenses.mit;
    maintainers = with maintainers; [ cole-h ];
    platforms = platforms.linux;
  };
}

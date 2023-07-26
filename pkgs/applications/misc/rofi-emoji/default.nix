{ stdenv
, lib
, fetchFromGitHub
, makeWrapper

, autoreconfHook
, pkg-config

, cairo
, glib
, libnotify
, rofi-unwrapped
, wl-clipboard
, xclip
, xsel
}:

stdenv.mkDerivation rec {
  pname = "rofi-emoji";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "Mange";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-P7AHLwqicKYj5I0Rl9B5mdD/v9iW9aihkNo7enonRF4=";
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
      --prefix PATH ":" ${lib.makeBinPath [ libnotify wl-clipboard xclip xsel ]}
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

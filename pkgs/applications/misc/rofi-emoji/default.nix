{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, substituteAll
, makeWrapper

, autoreconfHook
, pkgconfig

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
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "Mange";
    repo = pname;
    rev = "v${version}";
    sha256 = "0knsvsdff2c7ww94120bq92735qrfriyd28mi0n72ccb2iikyi8b";
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
    pkgconfig
  ];

  buildInputs = [
    cairo
    glib
    libnotify
    makeWrapper
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

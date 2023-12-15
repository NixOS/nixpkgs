{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, cairo
, json-glib
, pkg-config
, rofi-unwrapped
}:

stdenv.mkDerivation rec {
  pname = "rofi-blocks";
  version = "unstable-2023-10-27";

  src = fetchFromGitHub {
    owner = "OmarCastro";
    repo = "rofi-blocks";
    rev = "0a2ba561aa9a31586c0bc8203f8836a18a1f664e";
    sha256 = "sha256-U955hzd55xiV5XdQ18iUIwNLn2JrvuHsItgUSf6ww58=";
  };

  patches = [
    ./0001-Patch-plugindir-to-output.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    cairo
    rofi-unwrapped
    json-glib
  ];

  meta = with lib; {
    description = "Rofi modi that allows controlling rofi content through communication with an external program";
    homepage = "https://github.com/OmarCastro/rofi-blocks";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ edenkras ];
    platforms = platforms.linux;
  };
}

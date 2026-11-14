{ lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "keyboardio-udev-rules";
  version = "unstable-2024-05-24";

  # Source: https://github.com/keyboardio/Chrysalis/blob/6796adab2ec3ece9f9801c2a79593969f2882b99/src/renderer/screens/Help/Connection.js#L22
  # Also, when starting Chrysalis without these rules enabled, it will say which rules should be installed.
  src = [ ./keyboardio.rules ];

  dontUnpack = true;

  installPhase = ''
    install -Dpm644 $src $out/lib/udev/rules.d/50-keyboardio.rules
  '';

  meta = with lib; {
    homepage = "https://github.com/keyboardio/Chrysalis/";
    description = "udev rules that give the user permission to communicate with Keyboardio keyboards";
    platforms = platforms.linux;
    license = "unknown";
    maintainers = with maintainers; [ turion ];
  };
}

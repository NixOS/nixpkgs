{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "swhkd";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "waycrate";
    repo  = "swhkd";
    rev = version;
    hash = "sha256-mpE+//a44wwraCCpBTnWXslLROF2dSIcv/kdpxHLD4M=";
  };

  cargoHash = "sha256-H14YwK4Ow86UxVXoclCjk2xYtu8L/44zkzf9gpveAh8=";

  meta = with lib; {
    description = "Display protocol-independent hotkey daemon";
    longDescription = ''
      A display protocol-independent hotkey daemon made in Rust.
      Uses an easy-to-use configuration system inspired by sxhkd, so you can easily add or remove hotkeys.
      Attempts to be a drop-in replacement of sxhkd, meaning your sxhkd config file should be compatible with swhkd.
    '';
    license = licenses.bsd2;
    maintainers = with maintainers; [ mib ];
    platforms = platforms.linux;
  };
}

{ lib, rustPlatform, fetchFromGitHub, dbus, gdk-pixbuf, libnotify, makeWrapper, pkg-config, xorg
, enableAlsaUtils ? true, alsaUtils, coreutils
, enableNetwork ? true, dnsutils, iproute2, wirelesstools }:

let
  bins = lib.optionals enableAlsaUtils [ alsaUtils coreutils ]
    ++ lib.optionals enableNetwork [ dnsutils iproute2 wirelesstools ];
in

rustPlatform.buildRustPackage rec {
  pname = "dwm-status";
  version = "unstable-2021-05-04";

  src = fetchFromGitHub {
    owner = "Gerschtli";
    repo = pname;
    rev = "c5b1fda78a8175cb53df9d31ae037c58279df810";
    sha256 = "sha256-dJUQ7vuz9OC6eU00Snbbza63j01ms54sXO1kqheun+8=";
  };

  nativeBuildInputs = [ makeWrapper pkg-config ];
  buildInputs = [ dbus gdk-pixbuf libnotify xorg.libX11 ];

  cargoSha256 = "sha256-zSt6iNZ9hmvAgFEXzqfovRsMryVyFWHm68G7J3SMztY=";

  postInstall = lib.optionalString (bins != [])  ''
    wrapProgram $out/bin/dwm-status --prefix "PATH" : "${lib.makeBinPath bins}"
  '';

  meta = with lib; {
    description = "Highly performant and configurable DWM status service";
    homepage = "https://github.com/Gerschtli/dwm-status";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ gerschtli ];
    mainProgram = pname;
    platforms = platforms.linux;
  };
}

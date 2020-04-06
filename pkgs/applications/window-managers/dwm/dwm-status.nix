{ stdenv, lib, rustPlatform, fetchFromGitHub, dbus, gdk-pixbuf, libnotify, makeWrapper, pkgconfig, xorg
, enableAlsaUtils ? true, alsaUtils, coreutils
, enableNetwork ? true, dnsutils, iproute, wirelesstools }:

let
  bins = lib.optionals enableAlsaUtils [ alsaUtils coreutils ]
    ++ lib.optionals enableNetwork [ dnsutils iproute wirelesstools ];
in

rustPlatform.buildRustPackage rec {
  pname = "dwm-status";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "Gerschtli";
    repo = "dwm-status";
    rev = version;
    sha256 = "02sprsr7822ynkwpf3xdgmkdrgkw3vgijhlh65bayiv3b5lwb54n";
  };

  nativeBuildInputs = [ makeWrapper pkgconfig ];
  buildInputs = [ dbus gdk-pixbuf libnotify xorg.libX11 ];

  cargoSha256 = "0xybd6110b29ghl66kxfs64704qlhnn9jb5vl7lfk9sv62cs564i";

  postInstall = lib.optionalString (bins != [])  ''
    wrapProgram $out/bin/dwm-status --prefix "PATH" : "${stdenv.lib.makeBinPath bins}"
  '';

  meta = with stdenv.lib; {
    description = "Highly performant and configurable DWM status service";
    homepage = https://github.com/Gerschtli/dwm-status;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ gerschtli ];
    platforms = platforms.linux;
  };
}

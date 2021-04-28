{ lib, rustPlatform, fetchFromGitHub, dbus, gdk-pixbuf, libnotify, makeWrapper, pkg-config, xorg
, enableAlsaUtils ? true, alsaUtils, coreutils
, enableNetwork ? true, dnsutils, iproute2, wirelesstools }:

let
  bins = lib.optionals enableAlsaUtils [ alsaUtils coreutils ]
    ++ lib.optionals enableNetwork [ dnsutils iproute2 wirelesstools ];
in

rustPlatform.buildRustPackage rec {
  pname = "dwm-status";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "Gerschtli";
    repo = "dwm-status";
    rev = version;
    sha256 = "172qkzbi37j6wx81pyqqffi9wxbg3bf8nis7d15ncn1yfd5r4gqh";
  };

  nativeBuildInputs = [ makeWrapper pkg-config ];
  buildInputs = [ dbus gdk-pixbuf libnotify xorg.libX11 ];

  cargoSha256 = "041sd9zm1c3v6iihnwjcya2xg5yxb2y4biyxpjlfblz2srxa15dm";

  postInstall = lib.optionalString (bins != [])  ''
    wrapProgram $out/bin/dwm-status --prefix "PATH" : "${lib.makeBinPath bins}"
  '';

  meta = with lib; {
    description = "Highly performant and configurable DWM status service";
    homepage = "https://github.com/Gerschtli/dwm-status";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ gerschtli ];
    platforms = platforms.linux;
  };
}

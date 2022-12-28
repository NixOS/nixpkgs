{ lib, rustPlatform, fetchFromGitHub, dbus, gdk-pixbuf, libnotify, makeWrapper, pkg-config, xorg
, enableAlsaUtils ? true, alsa-utils, coreutils
, enableNetwork ? true, dnsutils, iproute2, wirelesstools }:

let
  bins = lib.optionals enableAlsaUtils [ alsa-utils coreutils ]
    ++ lib.optionals enableNetwork [ dnsutils iproute2 wirelesstools ];
in

rustPlatform.buildRustPackage rec {
  pname = "dwm-status";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "Gerschtli";
    repo = pname;
    rev = version;
    sha256 = "sha256-BCnEnBB0OCUwvhh4XEI2eOzfy34VHNFzbqqW26X6If0=";
  };

  nativeBuildInputs = [ makeWrapper pkg-config ];
  buildInputs = [ dbus gdk-pixbuf libnotify xorg.libX11 ];

  cargoSha256 = "sha256-ylB0XGmIPW7Dbc6eDS8FZsq1AOOqntx1byaH3XIal0I=";

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

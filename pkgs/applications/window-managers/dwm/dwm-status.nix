{ lib, rustPlatform, fetchFromGitHub, dbus, gdk-pixbuf, libnotify, makeWrapper, pkg-config, xorg
, enableAlsaUtils ? true, alsa-utils, coreutils
, enableNetwork ? true, dnsutils, iproute2, wirelesstools }:

let
  bins = lib.optionals enableAlsaUtils [ alsa-utils coreutils ]
    ++ lib.optionals enableNetwork [ dnsutils iproute2 wirelesstools ];
in

rustPlatform.buildRustPackage rec {
  pname = "dwm-status";
  version = "1.7.3";

  src = fetchFromGitHub {
    owner = "Gerschtli";
    repo = pname;
    rev = version;
    sha256 = "sha256-dkVo9NpGt3G6by9Of1kOlXaZn7xsVSvfNXq7KPO6HE4=";
  };

  nativeBuildInputs = [ makeWrapper pkg-config ];
  buildInputs = [ dbus gdk-pixbuf libnotify xorg.libX11 ];

  cargoSha256 = "sha256-QPnr7dUsq/RzuNLpbTRQbGB3zU6lNuPPPM9FmH4ydzY=";

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

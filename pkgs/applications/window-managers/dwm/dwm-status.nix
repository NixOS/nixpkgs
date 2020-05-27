{ stdenv, lib, rustPlatform, fetchFromGitHub, dbus, gdk-pixbuf, libnotify, makeWrapper, pkgconfig, xorg
, enableAlsaUtils ? true, alsaUtils, coreutils
, enableNetwork ? true, dnsutils, iproute, wirelesstools }:

let
  bins = lib.optionals enableAlsaUtils [ alsaUtils coreutils ]
    ++ lib.optionals enableNetwork [ dnsutils iproute wirelesstools ];
in

rustPlatform.buildRustPackage rec {
  pname = "dwm-status";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "Gerschtli";
    repo = "dwm-status";
    rev = version;
    sha256 = "1a3dpawxgi8d2a6w5jzvzm5q13rvqd656ris8mz77gj6f8qp7ddl";
  };

  nativeBuildInputs = [ makeWrapper pkgconfig ];
  buildInputs = [ dbus gdk-pixbuf libnotify xorg.libX11 ];

  cargoSha256 = "12b6fdhj13axhwf854n071dpiycg73g4kvl7igk1qn7l3gqwsfqn";

  postInstall = lib.optionalString (bins != [])  ''
    wrapProgram $out/bin/dwm-status --prefix "PATH" : "${stdenv.lib.makeBinPath bins}"
  '';

  meta = with stdenv.lib; {
    description = "Highly performant and configurable DWM status service";
    homepage = "https://github.com/Gerschtli/dwm-status";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ gerschtli ];
    platforms = platforms.linux;
  };
}

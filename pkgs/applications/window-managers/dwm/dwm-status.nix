{ stdenv, lib, rustPlatform, fetchFromGitHub, dbus, gdk_pixbuf, libnotify, makeWrapper, pkgconfig, xorg
, enableAlsaUtils ? true, alsaUtils }:

rustPlatform.buildRustPackage rec {
  name = "dwm-status-${version}";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "Gerschtli";
    repo = "dwm-status";
    rev = version;
    sha256 = "1nyi0p9snx9hddb4hliihskj4gdp933xs0f8kydyiprckikwiyjk";
  };

  nativeBuildInputs = [ makeWrapper pkgconfig ];
  buildInputs = [ dbus gdk_pixbuf libnotify xorg.libX11 ];

  cargoSha256 = "1ngdzzxnv4y6xprmkawf6s2696zgwiwgb6ykj5adb4knlx5c634d";

  postInstall = lib.optionalString enableAlsaUtils ''
    wrapProgram $out/bin/dwm-status \
      --prefix "PATH" : "${alsaUtils}/bin"
  '';

  meta = with stdenv.lib; {
    description = "Highly performant and configurable DWM status service";
    homepage = https://github.com/Gerschtli/dwm-status;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ gerschtli ];
    platforms = platforms.linux;
  };
}

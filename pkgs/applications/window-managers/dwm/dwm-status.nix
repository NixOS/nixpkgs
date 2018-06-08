{ stdenv, rustPlatform, fetchFromGitHub, dbus, gdk_pixbuf, libnotify, pkgconfig }:

rustPlatform.buildRustPackage rec {
  name = "dwm-status-${version}";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "Gerschtli";
    repo = "dwm-status";
    rev = version;
    sha256 = "0nw0iz78mnrmgpc471yjv7yzsaf7346mwjp6hm5kbsdclvrdq9d7";
  };

  buildInputs = [
    dbus
    gdk_pixbuf
    libnotify
    pkgconfig
  ];

  cargoSha256 = "0169k91pb7ipvi0m71cmkppp1klgp5ghampa7x0fxkyrvrf0dvqg";

  meta = with stdenv.lib; {
    description = "DWM status service which dynamically updates when needed";
    homepage = https://github.com/Gerschtli/dwm-status;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ gerschtli ];
    platforms = platforms.linux;
  };
}

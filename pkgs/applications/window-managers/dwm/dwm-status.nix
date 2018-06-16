{ stdenv, lib, rustPlatform, fetchFromGitHub, dbus, gdk_pixbuf, libnotify, makeWrapper, pkgconfig, xorg, alsaUtils }:

rustPlatform.buildRustPackage rec {
  name = "dwm-status-${version}";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "Gerschtli";
    repo = "dwm-status";
    rev = version;
    sha256 = "1mppj57h5yr0azypf5d2cgz2wv3k52mg3k4npyfhbmfy1393qbjs";
  };

  nativeBuildInputs = [ makeWrapper pkgconfig ];
  buildInputs = [ dbus gdk_pixbuf libnotify xorg.libX11 ];

  cargoSha256 = "0qr999hwrqn7a4n4kvbrpli7shxp9jchj8csxzsw951qmzq32qwv";

  # needed because alsaUtils is an optional runtime dependency
  postInstall = lib.optionalString (alsaUtils != null) ''
    wrapProgram $out/bin/dwm-status \
      --prefix "PATH" : "${alsaUtils}/bin"
  '';

  meta = with stdenv.lib; {
    description = "DWM status service which dynamically updates when needed";
    homepage = https://github.com/Gerschtli/dwm-status;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ gerschtli ];
    platforms = platforms.linux;
  };
}

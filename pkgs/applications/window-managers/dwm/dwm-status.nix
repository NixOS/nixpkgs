{ stdenv, lib, rustPlatform, fetchFromGitHub, dbus, gdk_pixbuf, libnotify, makeWrapper, pkgconfig, xorg
, enableAlsaUtils ? true, alsaUtils }:

rustPlatform.buildRustPackage rec {
  name = "dwm-status-${version}";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Gerschtli";
    repo = "dwm-status";
    rev = version;
    sha256 = "0r0irzm5y9xvqxrr8gvvn4x9c56qwgynljnzba4mh5s5dpbmz0iq";
  };

  nativeBuildInputs = [ makeWrapper pkgconfig ];
  buildInputs = [ dbus gdk_pixbuf libnotify xorg.libX11 ];

  cargoSha256 = "13ibcbk8shfajk200d8v2p6y3zfrz5dlvxqfw1zsm630s5dmy6qx";

  postInstall = lib.optionalString enableAlsaUtils ''
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

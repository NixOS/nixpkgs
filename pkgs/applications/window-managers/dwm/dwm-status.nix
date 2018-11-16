{ stdenv, lib, rustPlatform, fetchFromGitHub, dbus, gdk_pixbuf, libnotify, makeWrapper, pkgconfig, xorg
, enableAlsaUtils ? true, alsaUtils }:

rustPlatform.buildRustPackage rec {
  name = "dwm-status-${version}";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "Gerschtli";
    repo = "dwm-status";
    rev = version;
    sha256 = "0bv1jkqkf509akg3dvdy8b2q1kh8i75vw4n6a9rjvslx9s9nh6ca";
  };

  nativeBuildInputs = [ makeWrapper pkgconfig ];
  buildInputs = [ dbus gdk_pixbuf libnotify xorg.libX11 ];

  cargoSha256 = "0wbbbk99hxxlrkm389iqni9aqvw2laarwk6hhwsr4ph3y278qhi8";

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

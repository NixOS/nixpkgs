{ stdenv, lib, rustPlatform, fetchFromGitHub, dbus, gdk_pixbuf, libnotify, makeWrapper, pkgconfig, xorg
, enableAlsaUtils ? true, alsaUtils, bash, coreutils }:

let
  binPath = stdenv.lib.makeBinPath [
    alsaUtils bash coreutils
  ];
in

rustPlatform.buildRustPackage rec {
  name = "dwm-status-${version}";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "Gerschtli";
    repo = "dwm-status";
    rev = version;
    sha256 = "0mfzpyacd7i6ipbjwyl1zc0x3lnz0f4qqzsmsb07p047z95mw4v6";
  };

  nativeBuildInputs = [ makeWrapper pkgconfig ];
  buildInputs = [ dbus gdk_pixbuf libnotify xorg.libX11 ];

  cargoSha256 = "1cngcacsbzijs55k4kz8fidki3p8jblk3v5s21hjsn4glzjdbkmm";

  postInstall = lib.optionalString enableAlsaUtils ''
    wrapProgram $out/bin/dwm-status --prefix "PATH" : "${binPath}"
  '';

  meta = with stdenv.lib; {
    description = "Highly performant and configurable DWM status service";
    homepage = https://github.com/Gerschtli/dwm-status;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ gerschtli ];
    platforms = platforms.linux;
  };
}

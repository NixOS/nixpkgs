{ stdenv, lib, rustPlatform, fetchFromGitHub, dbus, gdk_pixbuf, libnotify, makeWrapper, pkgconfig, xorg, alsaUtils }:

let
  runtimeDeps = [ xorg.xsetroot ]
    ++ lib.optional (alsaUtils != null) alsaUtils;
in

rustPlatform.buildRustPackage rec {
  name = "dwm-status-${version}";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "Gerschtli";
    repo = "dwm-status";
    rev = version;
    sha256 = "0nw0iz78mnrmgpc471yjv7yzsaf7346mwjp6hm5kbsdclvrdq9d7";
  };

  nativeBuildInputs = [ makeWrapper pkgconfig ];
  buildInputs = [ dbus gdk_pixbuf libnotify ];

  cargoSha256 = "0169k91pb7ipvi0m71cmkppp1klgp5ghampa7x0fxkyrvrf0dvqg";

  postInstall = ''
    wrapProgram $out/bin/dwm-status \
      --prefix "PATH" : "${stdenv.lib.makeBinPath runtimeDeps}"
  '';

  meta = with stdenv.lib; {
    description = "DWM status service which dynamically updates when needed";
    homepage = https://github.com/Gerschtli/dwm-status;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ gerschtli ];
    platforms = platforms.linux;
  };
}

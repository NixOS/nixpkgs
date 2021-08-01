{ lib, fetchurl, appimageTools, pkgs }:

let
  pname = "chataigne";
  version = "1.8.0";
  name = "${pname}-${version}";
  src = fetchurl {
    url = "https://benjamin.kuperberg.fr/chataigne/user/data/Chataigne-linux-x64-1.8.0.AppImage";
    name="${pname}-${version}.AppImage";
    sha512 = "aHo+8U0jRczJHQwMMmvNYpWdamensO5hpIIHgaayvvI+NFoN4Hb9VhVY9vJgv5OkzktjhfTs4WsB+SHUDjQF2Q==";
  };
  curlWithGnutls = pkgs.curl.override { gnutlsSupport = true; sslSupport = false; };
in
appimageTools.wrapType2 {
  inherit name src;

  extraPkgs = pkgs: with pkgs; [
    bluez avahi curlWithGnutls libjack2 gtk3 SDL2 fuse libusb1 hidapi
    xorg.libX11 xorg.libXinerama xorg.xrandr xorg.libXcursor xorg.libXcomposite
    mesa alsaLib
  ];

  extraInstallCommands = ''
    mv $out/bin/{${name},${pname}}
  '';

  meta = with lib; {
    description = "Artist-friendly Modular Machine for Art and Technology";
    homepage = "https://benjamin.kuperberg.fr/chataigne";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ llelievr ];
    platforms = [ "x86_64-linux" ];
  };
}

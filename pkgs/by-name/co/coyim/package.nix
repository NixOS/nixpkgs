{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, pkg-config
, cairo
, gdk-pixbuf
, glib
, gnome
, wrapGAppsHook3
, gtk3
}:

buildGoModule {
  pname = "coyim";
  version = "0.4.1-unstable-2023-09-21";

  src = fetchFromGitHub {
    owner = "coyim";
    repo = "coyim";
    rev = "3f84daa8c27277543b1b4ad4536dde5100d9df12";
    sha256 = "sha256-lzhcUSBuAgYwcmdwnqNxKG0P6ZSjWeLS/g/gaF171D4=";
  };

  vendorHash = "sha256-zG7r/Db6XiwKoHRduGj3tEh/KT1hsuBoSGLYaZ+qO0Y=";

  nativeBuildInputs = [ pkg-config wrapGAppsHook3 ];

  buildInputs = [ glib cairo gdk-pixbuf gtk3 gnome.adwaita-icon-theme ];

  meta = {
    description = "Safe and secure chat client";
    mainProgram = "coyim";
    homepage = "https://coy.im/";
    license = lib.licenses.gpl3;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    broken = stdenv.isDarwin;
  };
}

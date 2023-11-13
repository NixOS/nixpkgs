{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, pkg-config
, cairo
, gdk-pixbuf
, glib
, gnome
, wrapGAppsHook
, gtk3
, gtk-mac-integration
}:

buildGoModule rec {
  pname = "coyim";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "coyim";
    repo = "coyim";
    # rev = "v${version}";
    rev = "3f84daa8c27277543b1b4ad4536dde5100d9df12";
    hash = "sha256-lzhcUSBuAgYwcmdwnqNxKG0P6ZSjWeLS/g/gaF171D4=";
  };

  vendorHash = "sha256-zG7r/Db6XiwKoHRduGj3tEh/KT1hsuBoSGLYaZ+qO0Y=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X main.BuildTag=${version}"
  ];

  nativeBuildInputs = [ pkg-config wrapGAppsHook ];

  buildInputs = [ glib cairo gdk-pixbuf gtk3 gnome.adwaita-icon-theme ]
    ++ lib.optionals stdenv.isDarwin [ gtk-mac-integration ];

  meta = with lib; {
    description = "a safe and secure chat client";
    homepage = "https://coy.im/";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}

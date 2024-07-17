{
  lib,
  stdenv,
  buildGoPackage,
  fetchFromGitHub,
  pkg-config,
  cairo,
  gdk-pixbuf,
  glib,
  gnome,
  wrapGAppsHook3,
  gtk3,
}:

buildGoPackage rec {
  pname = "coyim";
  version = "0.4.1";

  goPackagePath = "github.com/coyim/coyim";

  src = fetchFromGitHub {
    owner = "coyim";
    repo = "coyim";
    rev = "v${version}";
    sha256 = "sha256-PmB6POaHKEXzIAaz3lAbUOhtVOzrj5oXRk90giYo6SI=";
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    cairo
    gdk-pixbuf
    gtk3
    gnome.adwaita-icon-theme
  ];

  meta = with lib; {
    description = "a safe and secure chat client";
    mainProgram = "coyim";
    homepage = "https://coy.im/";
    license = licenses.gpl3;
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
    broken = stdenv.isDarwin;
  };
}

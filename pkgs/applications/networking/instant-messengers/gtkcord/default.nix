{ makeDesktopItem, lib, buildGoModule, fetchFromGitHub, pkg-config, glib, go, gtk3, libhandy }:

buildGoModule rec {
  pname = "gtkcord";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "diamondburned";
    repo = "gtkcord3";
    rev = "v${version}";
    sha256 = "0n9600s50zpx8kv89icrlxarm3633gnizg1sq1zpask8bbv2xnfd";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ glib gtk3 libhandy ];

  # No upstream desktop file yet: https://github.com/diamondburned/gtkcord3/issues/77
  desktopFile = makeDesktopItem {
    name = pname;
    desktopName = "gtkcord";
    exec = "gtkcord3";
    icon = "gtkcord3";
    categories = "GTK;GNOME;Chat;";
  };

  postInstall = ''
    install -Dt $out/share/applications/ "${desktopFile}"/share/applications/*
    install -D "$src/logo.png" $out/share/icons/hicolor/256x256/apps/gtkcord3.png
  '';

  vendorSha256 = "0kzq8x0qcjr443ydj05s2f8ybszc2jzqa2annadp3hry8x2va2in";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Lightweight Discord client which uses GTK3 for the user interface";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ skykanin ];
    homepage = "https://github.com/diamondburned/gtkcord3";
  };
}

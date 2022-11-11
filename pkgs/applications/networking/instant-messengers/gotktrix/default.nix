{ lib
, buildGoModule
, fetchFromGitHub
, gtk4
, glib
, gobject-introspection
, pkg-config
, go
}:

buildGoModule rec {
  pname = "gotktrix";
  version = "unstable-2022-09-29";

  src = fetchFromGitHub {
    owner = "diamondburned";
    repo = pname;
    rev = "3d9e8ac4810f7cb9d9ead7b4b13ffa6f5da8927f"; # compound
    sha256 = "sha256-VIV4vSntu3oCIE23f5fiYj8cxcKY1n4M4Xkf0MGhvxI=";
  };

  vendorSha256 = "sha256-R55tfTJL/bgNWTgmuBFRxIQleKS9zeDqvfez2VyzqjI=";

  buildInputs = [
    gtk4
    glib
    gobject-introspection
  ];

  nativeBuildInputs = [ pkg-config ];

  # Checking requires a working display
  doCheck = false;

  postPatch = ''
    sed -i '/DBusActivatable/d' .nix/com.github.diamondburned.gotktrix.desktop
    echo 'X-Purism-FormFactor=Workstation;Mobile;' >> .nix/com.github.diamondburned.gotktrix.desktop
  '';

  postInstall = ''
    install -Dm444 .nix/com.github.diamondburned.gotktrix.desktop -t $out/share/applications/
    install -Dm444 .github/logo-256.png -T $out/share/icons/hicolor/256x256/apps/gotktrix.png
  '';

  meta = with lib; {
    description = "Matrix client written in Go using GTK4";
    homepage = "https://github.com/diamondburned/gotktrix";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ chuangzhu ];
    platforms = platforms.linux;
  };
}

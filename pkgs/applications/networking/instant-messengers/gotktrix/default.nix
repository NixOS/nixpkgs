{ lib
, buildGoModule
, fetchFromGitHub
, gtk4
, glib
, gobject-introspection
, pkg-config
}:

buildGoModule rec {
  pname = "gotktrix";
  version = "unstable-2023-04-05";

  src = fetchFromGitHub {
    owner = "diamondburned";
    repo = pname;
    rev = "a8f876a383cc34dac18edddbe22be2dd494b8d0c"; # compound
    hash = "sha256-BuiA9UajdMhSrEfaXdu5DZlVhC4GVUdUpQDLMvKGrEk=";
  };

  vendorHash = "sha256-oo/j6i7slXILqyvj/EHojsyCZzJMGd10PTZaLvI1xoc=";

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

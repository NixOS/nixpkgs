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
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "diamondburned";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ZaE7L43fA9L5WbTAsBiIxlwYgjl1hMrtfrraAROz+7k=";
  };

  vendorSha256 = "sha256-k6T44aH1NogyrbUnflfEHkp0zpOOH1YFly/X2kwbMzs=";

  buildInputs = [
    gtk4
    glib
    gobject-introspection
  ];

  nativeBuildInputs = [ pkg-config ];

  # Checking requires a working display
  doCheck = false;

  postInstall = ''
    echo 'X-Purism-FormFactor=Workstation;Mobile;' >> .nix/com.github.diamondburned.gotktrix.desktop
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

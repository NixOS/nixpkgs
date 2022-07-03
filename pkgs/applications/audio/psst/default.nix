{ lib, fetchFromGitHub, rustPlatform, alsa-lib, atk, cairo, dbus, gdk-pixbuf, glib, gtk3, pango, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "psst";
  version = "unstable-2022-05-19";

  src = fetchFromGitHub {
    owner = "jpochyla";
    repo = pname;
    rev = "e403609e0916fe664fb1f28c7a259d01fa69b0e9";
    sha256 = "sha256-hpAP/m9aJsfh9FtwLqaKFZllnCQn9OSYLWuNZakZJnk=";
  };

  cargoSha256 = "sha256-gQ0iI2wTS5n5pItmQCmFXDs5L8nA2w5ZrZyZtpMlUro=";
  # specify the subdirectory of the binary crate to build from the workspace
  buildAndTestSubdir = "psst-gui";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    alsa-lib
    atk
    cairo
    dbus
    gdk-pixbuf
    glib
    gtk3
    pango
  ];

  postInstall = ''
    install -Dm444 psst-gui/assets/logo_512.png $out/share/icons/${pname}.png
  '';

  meta = with lib; {
    description = "Fast and multi-platform Spotify client with native GUI";
    homepage = "https://github.com/jpochyla/psst";
    license = licenses.mit;
    maintainers = with maintainers; [ vbrandl peterhoeg ];
  };
}

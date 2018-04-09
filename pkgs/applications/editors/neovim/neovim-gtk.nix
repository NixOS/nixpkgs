{ stdenv, fetchFromGitHub, rustPlatform
, gtk3
, atk
, pango
, cairo
, gdk_pixbuf
, glib
, gobjectIntrospection
}:

with rustPlatform;

buildRustPackage rec {
  name = "neovim-gtk-${version}";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "daa84";
    repo = "neovim-gtk";
    rev = "74d7417564012ff9a98df179470cedd5677b1018";
    sha256 = "0x031vjm2a9kr1cn2gsfd33bp7y43n4yznprdqb4ligm22ddlwjz";
  };

  propagatedBuildInputs= [
    gtk3
    gdk_pixbuf
    atk
    pango
    cairo
    glib
    gobjectIntrospection
  ];

  cargoSha256 = "0zpdsq96xffdcgi4b9s5gj0v0j4riqp0frqwqv8d4sczhlp2yq31";

  meta = with stdenv.lib; {
    description = "GTK ui for neovim written in rust using gtk-rs bindings. With ligatures support.";
    homepage = https://github.com/daa84/neovim-gtk;
    license = with licenses; [ gpl3 ];
    platforms = platforms.all;
  };
}

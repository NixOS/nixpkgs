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
    rev = "30b7fc87e1e92ac2bb102fd6af6a960fc75017ac";
    sha256 = "14yy611b6pgy3qay0g1nnwss66xckz0ljw7ixpsqbwi0imjvda27";
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

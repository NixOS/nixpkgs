{ stdenv
, fetchurl
, rustPlatform
, pkg-config
, wrapGAppsHook
, openssl
, gtk3
, gdk-pixbuf
, pango
, atk
, cairo
}:

rustPlatform.buildRustPackage rec {
  pname = "castor";
  version = "0.8.14";

  src = fetchurl {
    url = "https://git.sr.ht/~julienxx/castor/archive/${version}.tar.gz";
    sha256 = "1ykpmbimhfy3ys2hvv0mn8xiwxzdl43gpny1nc58i0gzv07ar8sc";
  };

  cargoSha256 = "04w49wka1vkb295lk6fzd6c5rwhzrqkp26hd5d94rx7bhcjmmb9w";
  verifyCargoDeps = true;

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    openssl
    gtk3
    gdk-pixbuf
    pango
    atk
    cairo
  ];

  postInstall = "make PREFIX=$out copy-data";

  # Sometimes tests fail when run in parallel
  checkFlags = [ "--test-threads=1" ];

  meta = with stdenv.lib; {
    description = "A graphical client for plain-text protocols written in Rust with GTK. It currently supports the Gemini, Gopher and Finger protocols";
    homepage = "https://sr.ht/~julienxx/Castor";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ fgaz ];
  };
}


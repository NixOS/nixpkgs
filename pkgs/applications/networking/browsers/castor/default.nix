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
  version = "0.8.16";

  src = fetchurl {
    url = "https://git.sr.ht/~julienxx/castor/archive/${version}.tar.gz";
    sha256 = "1qwsprwazkzcs70h219fhh5jj5s5hm1k120fn3pk4qivii4lyhah";
  };

  cargoSha256 = "0yn2kfiaz6d8wc8rdqli2pwffp5vb1v3zi7520ysrd5b6fc2csf2";

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


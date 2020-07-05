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
  version = "0.8.15";

  src = fetchurl {
    url = "https://git.sr.ht/~julienxx/castor/archive/${version}.tar.gz";
    sha256 = "1i6550akxg78c9bh9111c4458ry1nmp3xh7ik7s2zqrp7lmxaf46";
  };

  cargoSha256 = "1y047cm46l5hph3n48h60xvyh2hr0yagzswp375kiil96ndk206i";

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


{ lib
, fetchFromSourcehut
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

  src = fetchFromSourcehut {
    owner = "~julienxx";
    repo = pname;
    rev = version;
    sha256 = "0rwg1w7srjwa23mkypl8zk6674nhph4xsc6nc01f6g5k959szylr";
  };

  cargoSha256 = "0dm3walwi3vzpk69l7nz6yl6w49676x8pjnigpn67q4bn7lpaqb1";

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
  dontUseCargoParallelThreads = true;

  meta = with lib; {
    description = "A graphical client for plain-text protocols written in Rust with GTK. It currently supports the Gemini, Gopher and Finger protocols";
    homepage = "https://sr.ht/~julienxx/Castor";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
  };
}

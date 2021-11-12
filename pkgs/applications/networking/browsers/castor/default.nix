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
  version = "0.8.18";

  src = fetchFromSourcehut {
    owner = "~julienxx";
    repo = pname;
    rev = version;
    sha256 = "sha256-sv6hiSTVFe3jxNuaM6Jyn7UeqFqUNmRvYtWfkJTJ4tA=";
  };

  cargoSha256 = "sha256-/IHxvTW9VYZmgjmDh0zJFDQqfw/H5CXVwEuLKq6Hnys=";

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

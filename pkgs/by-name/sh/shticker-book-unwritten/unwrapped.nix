{
  rustPlatform,
  fetchCrate,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "shticker-book-unwritten";
  version = "1.3.0";

  src = fetchCrate {
    inherit (finalAttrs) version;
    crateName = "shticker_book_unwritten";
    hash = "sha256-ncS0vn89PEYA7aRzXEfJMa2UR1EH31eka7BdksnGHtw=";
  };

  cargoHash = "sha256-6n3IsuLWnOef5bPm/i+BjWX+zQElBorr1qy/z+c+5jM=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];
})

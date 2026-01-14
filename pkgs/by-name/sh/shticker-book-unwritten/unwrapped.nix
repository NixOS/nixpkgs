{
  rustPlatform,
  fetchCrate,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "shticker-book-unwritten";
  version = "1.2.0";

  src = fetchCrate {
    inherit version;
    crateName = "shticker_book_unwritten";
    hash = "sha256-jI2uL8tMUmjZ5jPkCV2jb98qtKwi9Ti4NVCPfuO3iB4=";
  };

  cargoHash = "sha256-0eumZoAL8/nkeFS+sReCAYKHiXiqZHfdC/9Ao5U6/SQ=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];
}

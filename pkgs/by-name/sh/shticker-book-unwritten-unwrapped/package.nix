{
  rustPlatform,
  fetchCrate,
  pkg-config,
  openssl,
  lib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "shticker-book-unwritten";
  version = "1.2.0";

  src = fetchCrate {
    inherit (finalAttrs) version;
    crateName = "shticker_book_unwritten";
    hash = "sha256-jI2uL8tMUmjZ5jPkCV2jb98qtKwi9Ti4NVCPfuO3iB4=";
  };

  cargoHash = "sha256-0eumZoAL8/nkeFS+sReCAYKHiXiqZHfdC/9Ao5U6/SQ=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = with lib; {
    description = "Minimal CLI launcher for the Toontown Rewritten MMORPG";
    mainProgram = "shticker_book_unwritten";
    homepage = "https://github.com/JonathanHelianthicusDoe/shticker_book_unwritten";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.reedrw ];
    platforms = platforms.linux;
  };
})

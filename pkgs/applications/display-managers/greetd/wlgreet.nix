{
  lib,
  rustPlatform,
  fetchFromSourcehut,
  autoPatchelfHook,
  gcc-unwrapped,
  wayland,
  libxkbcommon,
}:

rustPlatform.buildRustPackage rec {
  pname = "wlgreet";
  version = "0.5.0";

  src = fetchFromSourcehut {
    owner = "~kennylevinsen";
    repo = pname;
    rev = version;
    hash = "sha256-TQTHFBOTxtSuzrAG4cjZ9oirl80xc0rPdYeLJ0t39DQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-ITo9qvcT5aOybWLV7kn9BZbux6uxx1RwRGWCGQYdZ2I=";

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ gcc-unwrapped ];

  runtimeDependencies = map lib.getLib [
    gcc-unwrapped
    wayland
    libxkbcommon
  ];

  meta = with lib; {
    description = "Raw wayland greeter for greetd, to be run under sway or similar";
    mainProgram = "wlgreet";
    homepage = "https://git.sr.ht/~kennylevinsen/wlgreet";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}

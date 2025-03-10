{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "bibiman";
  version = "0.11.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-b684N4QFpj/bpDF3XdpUACPXQBXUFOiy3To7y1GY1ug=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-RWLKiYyUQUgAPPWTugp1G05X3B9SbknmpVLc7eSdn8U=";

  meta = with lib; {
    description = "A TUI for fast and simple interacting with your BibLaTeX database";
    homepage = "https://codeberg.org/lukeflo/bibiman";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ clementpoiret ];
    mainProgram = "bibiman";
    platforms = platforms.x86_64;
  };
}

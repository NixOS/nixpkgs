{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "swapview";
  version = "0.1.0-unstable-2023-12-03";

  src = fetchFromGitHub {
    owner = "lilydjwg";
    repo = "swapview";
    rev = "cc8e863acd2084413b91572357dab34551c27ed7";
    sha256 = "sha256-H5jMdmtZoN9nQfjXFQyYbuvPY58jmEP2j/XWGdBocFo=";
  };

  cargoHash = "sha256-hAesRDDHcZEa4sq7Wj1S1p4i9MDaGA5l1iW50jeOSeM=";

  meta = with lib; {
    description = "Simple program to view processes' swap usage on Linux";
    mainProgram = "swapview";
    homepage = "https://github.com/lilydjwg/swapview";
    platforms = platforms.linux;
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ oxalica ];
  };
}

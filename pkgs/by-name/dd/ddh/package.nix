{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "ddh";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "darakian";
    repo = "ddh";
    rev = version;
    sha256 = "XFfTpX4c821pcTAJZFUjdqM940fRoBwkJC6KTknXtCw=";
  };

  cargoHash = "sha256-rl9+3JSFkqZwaIWCuZBDhDF0QBr+aB2I7kB1o9LWCEw=";

  meta = with lib; {
    description = "Fast duplicate file finder";
    longDescription = ''
      DDH traverses input directories and their subdirectories.
      It also hashes files as needed and reports findings.
    '';
    homepage = "https://github.com/darakian/ddh";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ h7x4 ];
    platforms = platforms.all;
    mainProgram = "ddh";
  };
}

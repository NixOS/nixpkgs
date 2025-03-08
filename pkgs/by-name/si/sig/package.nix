{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "sig";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "ynqa";
    repo = "sig";
    rev = "v${version}";
    hash = "sha256-685VBQ64B+IbSSyqtVXtOgs4wY85WZ/OceHL++v5ip4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-x4/vCFbC+kxhne4iRjuJy4L6QRpRKrJU3r+TPpDh4Pw=";

  meta = {
    description = "Interactive grep (for streaming)";
    homepage = "https://github.com/ynqa/sig";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ qaidvoid ];
    mainProgram = "sig";
  };
}

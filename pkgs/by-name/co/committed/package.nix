{ lib, fetchFromGitHub, rustPlatform, }:
rustPlatform.buildRustPackage rec {
  pname = "committed";
  version = "1.0.20";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = pname;
    rev = "e0a4ba358ac0e6292e750f61b74f77a347eb10ad";
    hash = "sha256-HqZYxV2YjnK7Q3A7B6yVFXME0oc3DZ4RfMkDGa2IQxA=";
  };
  cargoHash = "sha256-AmAEGVWq6KxLtiHDGIFVcoP1Wck8z+P9mnDy0SSSJNM=";

  meta = {
    homepage = "https://github.com/crate-ci/committed";
    description = "Nitpicking commit history since beabf39";
    mainProgram = "committed";
    license = with lib.licenses; [ mit asl20 ];
    maintainers = with lib.maintainers; [ nydragon ];
    platforms = lib.platforms.linux;
  };
}

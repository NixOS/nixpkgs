{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "re-plistbuddy";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "viraptor";
    repo = "re-plistbuddy";
    tag = version;
    hash = "sha256-Iumrj0JLpdrS3cg3jAj/Wrbx7PthlCnTuRMYsYdywyw=";
  };

  cargoHash = "sha256-RyHM6CMxdhDJrg6mGt8jQCDLVjt0BiLYswelOHoellw=";

  meta = {
    description = "Open reimplementation of Apple's PlistBuddy and plutil";
    homepage = "https://github.com/viraptor/re-plistbuddy";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ viraptor ];
    platforms = lib.platforms.darwin;
  };
}

{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "wttrbar";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "bjesus";
    repo = "wttrbar";
    rev = version;
    hash = "sha256-9qAluu9W6OG/G1SmAEOe97mUS83PZL/oLYUsIJNunwY=";
  };

  buildInputs = lib.optionals stdenv.isDarwin (with darwin.apple_sdk_11_0.frameworks; [ Security SystemConfiguration ]);

  cargoHash = "sha256-AVlI2Yi3Gx9jCgP2O5NfaTvUFHdw6HPRmsMqbPFvxf8=";

  meta = {
    description = "A simple but detailed weather indicator for Waybar using wttr.in";
    homepage = "https://github.com/bjesus/wttrbar";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
    mainProgram = "wttrbar";
  };
}

{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "wttrbar";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "bjesus";
    repo = "wttrbar";
    rev = version;
    hash = "sha256-kRrVqUfkrSK/9z3Hj4J+mKcdV7JdTzjhxlVRa/kf8sw=";
  };

  buildInputs = lib.optionals stdenv.isDarwin (with darwin.apple_sdk_11_0.frameworks; [ Security SystemConfiguration ]);

  cargoHash = "sha256-HxSyGME95FWR5VwodmrMUX0jPlfE9SJV0WBbICuuTok=";

  meta = {
    description = "A simple but detailed weather indicator for Waybar using wttr.in";
    homepage = "https://github.com/bjesus/wttrbar";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
    mainProgram = "wttrbar";
  };
}

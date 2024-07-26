{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "wttrbar";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "bjesus";
    repo = "wttrbar";
    rev = version;
    hash = "sha256-XgBPZl5msKICIrUJZz2gj/hZjVAv0HpVKa69/KiLwnI=";
  };

  buildInputs = lib.optionals stdenv.isDarwin (with darwin.apple_sdk_11_0.frameworks; [ Security SystemConfiguration ]);

  cargoHash = "sha256-JGJJ94rzHTQNR6rzFPWnFHH3t0fL1tvMeEN5NMzRtHM=";

  meta = {
    description = "A simple but detailed weather indicator for Waybar using wttr.in";
    homepage = "https://github.com/bjesus/wttrbar";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
    mainProgram = "wttrbar";
  };
}

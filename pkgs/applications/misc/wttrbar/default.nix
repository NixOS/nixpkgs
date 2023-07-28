{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "wttrbar";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "bjesus";
    repo = "wttrbar";
    rev = version;
    hash = "sha256-RQeRDu8x6OQAD7VYT7FwBfj8gxn1nj6hP60oCIiuAgg=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk_11_0.frameworks.Security ];

  cargoHash = "sha256-hJCEA6m/iZuSjWRbbaoJ5ryG0z5U/IWhbEvNAohFyjg=";

  meta = {
    description = "A simple but detailed weather indicator for Waybar using wttr.in";
    homepage = "https://github.com/bjesus/wttrbar";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}

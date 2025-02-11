{
  lib,
  stdenv,
  darwin,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "slumber";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "LucasPickering";
    repo = "slumber";
    tag = "v${version}";
    hash = "sha256-ojHVH/GE2FonqqxpGK6t/AmCaeOS1TkWMt89iUt5i1s=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-1xWSFM1LSFKTaGWgAK9M2TI5Gqes29A/L1WMDj+GSIA=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.AppKit ];

  meta = with lib; {
    description = "Terminal-based HTTP/REST client";
    homepage = "https://slumber.lucaspickering.me";
    changelog = "https://github.com/LucasPickering/slumber/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    mainProgram = "slumber";
    maintainers = with maintainers; [ javaes ];
  };
}

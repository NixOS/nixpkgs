{ lib
, stdenv
, testers
, fetchFromGitHub
, rustPlatform
, darwin
, numbat
}:

rustPlatform.buildRustPackage rec {
  pname = "numbat";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "numbat";
    rev = "v${version}";
    hash = "sha256-KX/V1cVZoPtkP/ehnvcTeaQavHlHP6NJ7g+FbOaYKC4=";
  };

  cargoHash = "sha256-skCvIMz50GqveyawVHicpEqMknvZuYNvp1u+gW4wG8A=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  passthru.tests.version = testers.testVersion {
    package = numbat;
  };

  meta = with lib; {
    description = "High precision scientific calculator with full support for physical units";
    longDescription = ''
      A statically typed programming language for scientific computations
      with first class support for physical dimensions and units
    '';
    homepage = "https://numbat.dev";
    changelog = "https://github.com/sharkdp/numbat/releases/tag/v${version}";
    license = with licenses; [ asl20 mit ];
    mainProgram = "numbat";
    maintainers = with maintainers; [ giomf ];
  };
}

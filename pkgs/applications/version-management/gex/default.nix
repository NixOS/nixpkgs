{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libgit2_1_6
}:

rustPlatform.buildRustPackage rec {
  pname = "gex";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "Piturnah";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ADVF+Kb0DDiR3dS43uzhefFFEg1O8IC22i5fmziEp6I=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libgit2_1_6
  ];

  cargoHash = "sha256-XBBZ56jvBtYI5J/sSc4ckk/KXzCHNgM9A4jGolGKh2E=";

  meta = with lib; {
    description = "Git Explorer: cross-platform git workflow improvement tool inspired by Magit";
    homepage = "https://github.com/Piturnah/gex";
    changelog = "https://github.com/Piturnah/gex/releases/tag/${src.rev}";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ azd325 evanrichter piturnah ];
  };
}

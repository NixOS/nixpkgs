{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, libgit2
}:

rustPlatform.buildRustPackage rec {
  pname = "gex";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "Piturnah";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-//sQ0s8bBQzuu5aO3RjPRjFuVYiGW6BwSPoCWKAx9DQ=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libgit2 ];

  cargoHash = "sha256-rkhkFnRDtMTWFM+E5C4jR7TWtHdy3WUtIzvGDDLHqtE=";

  meta = with lib; {
    description = "Git Explorer: cross-platform git workflow improvement tool inspired by Magit";
    homepage = "https://github.com/Piturnah/gex";
    changelog = "https://github.com/Piturnah/gex/releases/tag/${src.rev}";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ azd325 evanrichter piturnah ];
  };
}

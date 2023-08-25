{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libgit2_1_6
}:

rustPlatform.buildRustPackage rec {
  pname = "gex";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "Piturnah";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-iCK3fiVchbfQh5JPHzBN/b24dkoXKW5dJdCsyoG0Kvw=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libgit2_1_6
  ];

  cargoHash = "sha256-5w8VzYoevWesMGQJe4rDbugCFQrE1LDNb69CaJ2bQ0w=";

  meta = with lib; {
    description = "Git Explorer: cross-platform git workflow improvement tool inspired by Magit";
    homepage = "https://github.com/Piturnah/gex";
    changelog = "https://github.com/Piturnah/gex/releases/tag/${src.rev}";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ azd325 evanrichter piturnah ];
  };
}

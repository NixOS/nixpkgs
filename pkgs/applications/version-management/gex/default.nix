{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libgit2_1_6
}:

rustPlatform.buildRustPackage rec {
  pname = "gex";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "Piturnah";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-OCC2kHPHWFwqdE0THNZbH7d3gxTBD5MUMWY6PO5GuHU";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libgit2_1_6
  ];

  cargoHash = "sha256-28sMY47LAdaGmPNmxeu/w1Pn6AV3JlWbxFcit5pLkI0";

  meta = with lib; {
    description = "Git Explorer: cross-platform git workflow improvement tool inspired by Magit";
    homepage = "https://github.com/Piturnah/gex";
    changelog = "https://github.com/Piturnah/gex/releases/tag/${src.rev}";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ azd325 evanrichter piturnah ];
  };
}

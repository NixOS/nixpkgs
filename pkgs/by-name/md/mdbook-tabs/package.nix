{
  lib,
  fetchFromGitHub,
  rustPlatform,
  perl,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-tabs";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "RustForWeb";
    repo = "mdbook-plugins";
    rev = "v${version}";
    hash = "sha256-IyIUJH5pbuvDarQf7yvrStMIb5HdimudYF+Tq/+OtvY=";
  };

  cargoHash = "sha256-/UM85Lhq52MFTjczPRuXENPJOQkjiHLWGPPW/VD9kBQ=";

  nativeBuildInputs = [
    perl
  ];

  cargoBuildFlags = [
    "--bin"
    "mdbook-tabs"
  ];

  meta = with lib; {
    description = "mdBook plugin for rendering content in tabs";
    license = with licenses; [
      mit
    ];
    mainProgram = "mdbook-tabs";
    maintainers = with maintainers; [ redianthus ];
  };
}

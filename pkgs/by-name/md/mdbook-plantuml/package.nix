{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage {
  pname = "mdbook-plantuml";
  version = "v2.0.0";

  src = fetchFromGitHub {
    owner = "sytsereitsma";
    repo = "mdbook-plantuml";
    rev = "dae70cfd3deb8438127cc369a92ecefe24acb6a2";
    hash = "sha256-PNVWeXbYDX/PYFCSPKKeqdbhLl9hmDOK7i7lWQlbEK0=";
  };

  cargoHash = "sha256-8DKnINclcX0WwRtCTv7DUBx/6omRvda3qg3a1g1lyFA=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = {
    description = "mdBook preprocessor to render PlantUML diagrams to png images in the book output directory";
    mainProgram = "mdbook-plantuml";
    homepage = "https://github.com/sytsereitsma/mdbook-plantuml";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jcouyang
      matthiasbeyer
    ];
  };
}

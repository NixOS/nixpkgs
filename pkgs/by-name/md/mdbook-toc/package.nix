{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-toc";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "badboy";
    repo = "mdbook-toc";
    tag = version;
    sha256 = "sha256-uZoruFNhvhUNUL/m/vUoft+pnXvF/GYvNY21ERsIjBM=";
  };

  cargoHash = "sha256-fp5ZL0aAk1CavWKZLAevLUIuVl9VuHPyrAZ2dPc/eoE=";

  meta = {
    description = "Preprocessor for mdbook to add inline Table of Contents support";
    mainProgram = "mdbook-toc";
    homepage = "https://github.com/badboy/mdbook-toc";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
  };
}

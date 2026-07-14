{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdbook-toc";
  version = "0.15.4";

  src = fetchFromGitHub {
    owner = "badboy";
    repo = "mdbook-toc";
    tag = finalAttrs.version;
    sha256 = "sha256-mmmAMZC/YEAMRd8Yu8dGwheHM5CvzS0TpVmGzM08vEY=";
  };

  cargoHash = "sha256-AlYik588J013Ee6YMF0sWAf5DfK2OVcTR3SxHT/v8nI=";

  meta = {
    description = "Preprocessor for mdbook to add inline Table of Contents support";
    mainProgram = "mdbook-toc";
    homepage = "https://github.com/badboy/mdbook-toc";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
  };
})

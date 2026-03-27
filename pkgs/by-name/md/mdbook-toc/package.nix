{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdbook-toc";
  version = "0.15.3";

  src = fetchFromGitHub {
    owner = "badboy";
    repo = "mdbook-toc";
    tag = finalAttrs.version;
    sha256 = "sha256-nQMVba6jwfatGpV1jhwzdNlMY7XUGpHU3TqZ1yMy6Q0=";
  };

  cargoHash = "sha256-ksLapG9MDGDgKNZIg7Kx9CpzCTchkQdmMlWAEczdbRg=";

  meta = {
    description = "Preprocessor for mdbook to add inline Table of Contents support";
    mainProgram = "mdbook-toc";
    homepage = "https://github.com/badboy/mdbook-toc";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
  };
})

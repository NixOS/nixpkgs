{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rusti-cal";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "arthurhenrique";
    repo = "rusti-cal";
    rev = "v${finalAttrs.version}";
    hash = "sha256-pdsP2nuJh30BzqIyxSQXak/rceA4hI9jBYy1dDVEIvI=";
  };

  cargoHash = "sha256-9nd8xm3jAFouRYKSFpx3vQQaI/2wQzTaaehXjqljIfw=";

  meta = {
    description = "Minimal command line calendar, similar to cal";
    mainProgram = "rusti-cal";
    homepage = "https://github.com/arthurhenrique/rusti-cal";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.detegr ];
  };
})

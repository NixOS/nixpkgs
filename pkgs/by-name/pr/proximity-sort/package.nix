{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "proximity-sort";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "jonhoo";
    repo = "proximity-sort";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IW+NWFLuRbtRWbb9Hoxwi4rQKICdxUJD70zCprq3fg4=";
  };

  cargoHash = "sha256-jSjPbb7a/M6iRjhsvjbxrC0kpakHUnhBk996Np/Ashw=";

  meta = {
    description = "Simple command-line utility for sorting inputs by proximity to a path argument";
    homepage = "https://github.com/jonhoo/proximity-sort";
    license =
      with lib.licenses;
      OR [
        mit
        asl20
      ];
    maintainers = [ ];
    mainProgram = "proximity-sort";
  };
})

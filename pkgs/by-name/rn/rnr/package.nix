{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rnr";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "ismaelgv";
    repo = "rnr";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-vuYFh7k7dNCOnB5jqP8MIBIWFOVxRmv0+qvCXkJchtA=";
  };

  cargoHash = "sha256-2YvpO8K5Y8Ul2k0sJXWMgrHnGY8e1sEcIZNWIEpKfqs=";

  meta = {
    description = "Command-line tool to batch rename files and directories";
    mainProgram = "rnr";
    homepage = "https://github.com/ismaelgv/rnr";
    changelog = "https://github.com/ismaelgv/rnr/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})

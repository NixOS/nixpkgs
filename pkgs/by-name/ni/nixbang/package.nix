{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "nixbang";
  version = "0.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "madjar";
    repo = "nixbang";
    tag = finalAttrs.version;
    hash = "sha256-bKMI6xDukZMWCLs9dFNcsLMFohU+WaM4CSgC4/Mo888=";
  };

  build-system = with python3Packages; [ setuptools ];

  meta = {
    homepage = "https://github.com/madjar/nixbang";
    description = "Special shebang to run scripts in a nix-shell";
    mainProgram = "nixbang";
    maintainers = [ lib.maintainers.madjar ];
    platforms = lib.platforms.all;
  };
})

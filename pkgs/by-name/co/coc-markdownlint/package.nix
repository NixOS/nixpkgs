{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-markdownlint";
  version = "0-unstable-2026-03-04";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-markdownlint";
    rev = "4f3410753308b8bf5c45518b6f39aee6d29a8bbd";
    hash = "sha256-9S3mXE70PqBJIaRRycluwQ8rdQ+9KMUfY10170ek//w=";
  };

  npmDepsHash = "sha256-XXOW5gekzDOl02JNuIQD71Ufm9W+zOIeUO1IrJ7fx5Y=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Markdownlint extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-markdownlint";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}

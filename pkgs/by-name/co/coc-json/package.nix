{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "coc-json";
  version = "1.9.10";

  src = fetchFromGitHub {
    owner = "neoclide";
    repo = "coc-json";
    tag = finalAttrs.version;
    hash = "sha256-6gbkZjFPbCoRy+iOF+cqmCTo7dZAiWvEGm7iGyFw1QI=";
  };

  npmDepsHash = "sha256-5myDWKh/Z1ozyhu0u8nR8xB4m9+vxXImJz582jerSws=";

  npmBuildScript = "prepare";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "JSON language extension for coc.nvim";
    homepage = "https://github.com/neoclide/coc-json";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})

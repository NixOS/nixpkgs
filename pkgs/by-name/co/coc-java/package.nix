{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "coc-java";
  version = "1.26.1";

  src = fetchFromGitHub {
    owner = "neoclide";
    repo = "coc-java";
    tag = finalAttrs.version;
    hash = "sha256-OKqZk1pt8qt6O+kHYdhAAha5S8YTJBFQPn7oIrjGZgI=";
  };

  npmDepsHash = "sha256-FF7EAf6SvO1sGMIE8FCS7MbnpVwVUwVg0SVUsX+i7zg=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Java extension for coc.nvim";
    homepage = "https://github.com/neoclide/coc-java";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})

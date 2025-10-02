{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "coc-git";
  version = "2.7.7";

  src = fetchFromGitHub {
    owner = "neoclide";
    repo = "coc-git";
    tag = finalAttrs.version;
    hash = "sha256-5AN5G9u4ZGDrP1dfQal9KpOyMZrVqXnxDslnuMwJ9SU=";
  };

  patches = [
    ./fix-package-lock.patch
  ];

  npmDepsHash = "sha256-vkAATI0vs1oeMr0/iQ8YDt3r+aJo6ND/x4mY/TlRwpg=";

  npmBuildScript = "prepare";

  meta = {
    description = "Git integration of coc.nvim";
    homepage = "https://github.com/neoclide/coc-git";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})

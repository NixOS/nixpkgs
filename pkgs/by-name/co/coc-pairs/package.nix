{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "coc-pairs";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "neoclide";
    repo = "coc-pairs";
    tag = finalAttrs.version;
    hash = "sha256-CUNnNS8mRjyVyjFw4dLnFpskdZNn/+UjVwOcuZJkeNw=";
  };

  patches = [
    ./package-lock-fix.patch
  ];

  npmDepsHash = "sha256-yIMed7x5EzJMMhsA/O08kLpVYMujyJq1qol/KilxxTs=";

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Basic auto pairs extension for coc.nvim";
    homepage = "https://github.com/neoclide/coc-pairs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})

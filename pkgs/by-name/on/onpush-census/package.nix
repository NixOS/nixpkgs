{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "onpush-census";
  version = "0.1.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "MuslumYilmaz";
    repo = "onpush-census";
    rev = "11a759b1d55f6eb829b335ed18e04dc44fad42f3";
    hash = "sha256-R2UlY/wJNSM+9xUOYXHCydnPW3W3HuNFoR0qPiPITKo=";
  };

  npmDepsHash = "sha256-kj6ZpBQ5VFa5XKagtCzkcZnN+6A5gpHRAGjGYv+bpJU=";

  dontNpmBuild = true;

  meta = {
    description = "Static OnPush readiness check for Angular workspaces";
    homepage = "https://frontendatlas.com/research/angular-onpush-readiness";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.MuslumYilmaz ];
    mainProgram = "onpush-census";
    platforms = lib.platforms.all;
  };
})

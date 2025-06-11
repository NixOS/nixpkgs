{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "redoc-cli";
  version = "0.13.21";

  src = fetchFromGitHub {
    owner = "Redocly";
    repo = "redoc";
    rev = "d3ac16f4774ae5b5f698b4e8f4c1d3f5a009d361";
    hash = "sha256-LmNb+m1Ng/53SPUqrr/AmxNMiWsrMGCKow0DW/9t3Do=";
  };

  sourceRoot = "${src.name}/cli";

  npmDepsHash = "sha256-XL4D7+hb0zOxAr/aRo2UOg4UOip3oewbffsnkFddmWw=";

  postPatch = ''
    ln -s npm-shrinkwrap.json package-lock.json
  '';

  dontNpmBuild = true;

  meta = {
    description = "OpenAPI/Swagger-generated API Reference Documentation";
    homepage = "https://github.com/Redocly/redoc/tree/redoc-cli/cli";
    license = lib.licenses.mit;
    mainProgram = "redoc-cli";
    maintainers = with lib.maintainers; [ veehaitch ];
    # https://github.com/NixOS/nixpkgs/issues/272217
    broken = true;
  };
}

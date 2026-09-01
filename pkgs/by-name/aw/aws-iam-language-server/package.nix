{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "aws-iam-language-server";
  version = "0.0.38";

  src = fetchFromGitHub {
    owner = "mbarneyjr";
    repo = "aws-iam-language-server";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-GypV7Ey4ZVYJKszt2kX0xMH+V8LLYv6msDJIOeID4tk=";
  };

  npmDepsHash = "sha256-MvqbZR2GLCzmijCdGi4A58ZxbZjzCYom5uF/BT2iAKw=";

  doCheck = true;
  checkPhase = ''
    npm test
  '';

  __structuredAttrs = true;

  meta = {
    description = "AWS IAM Policy Language Server";
    mainProgram = "aws-iam-language-server";
    homepage = "https://github.com/mbarneyjr/aws-iam-language-server";
    license = lib.licenses.mit;
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = with lib.maintainers; [
      mbarneyjr
    ];
  };
})

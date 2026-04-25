{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "aws-iam-language-server";
  version = "0.0.35";

  src = fetchFromGitHub {
    owner = "mbarneyjr";
    repo = "aws-iam-language-server";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-EcaJitilBgLzQGRLgfWnk/mrOF1ncpD3UZETh58/V+w=";
  };

  npmDepsHash = "sha256-AptI7QS7uDYekklZ4tP0QyuGfhDn75W0bCQxdxx+gME=";

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

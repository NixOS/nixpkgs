{
  lib,
  fetchurl,
  nodejs,
  buildNpmPackage,
}:

buildNpmPackage (finalAttrs: {
  pname = "mdx-language-server";
  version = "0.5.2";

  src = fetchurl {
    url = "https://registry.npmjs.org/@mdx-js/language-server/-/language-server-${finalAttrs.version}.tgz";
    hash = "sha256-8ef9dVVsH5yTva9ymY+EAZTz6FOZ7Zgu9kOv1wLaK4w=";
  };

  postPatch = ''
    ln -s ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-IONV1wxETazDaXzYfqiYrM+A8c36VcnlzTj3lmxA9ug=";

  dontNpmBuild = true;

  meta = {
    description = "Language server for MDX";
    homepage = "https://github.com/mdx-js/mdx-analyzer/tree/main/packages/language-server";
    changelog = "https://github.com/mdx-js/mdx-analyzer/blob/@mdx-js/language-server@${finalAttrs.version}/packages/language-server/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ThaoTranLePhuong ];
    mainProgram = "mdx-language-server";
  };
})

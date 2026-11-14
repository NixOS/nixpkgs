{
  buildNpmPackage,

  version,
  server-src,
}:

buildNpmPackage (finalAttrs: {
  name = "euro-office-server-Common";
  src = server-src;
  sourceRoot = "${finalAttrs.src.name}/Common";
  npmDepsHash = "sha256-zFGqDtnNFzXCwp6uvK04GDMRG6BATv6ti3Wi8ikLjBU=";
  dontNpmBuild = true;
  postPatch = ''
    # https://github.com/ONLYOFFICE/build_tools/blob/ef8153c053bed41909ceb0762b124f8fe7faa0a7/scripts/build_server.py#L34
    sed -e "s/^const buildVersion = '[0-9.]*'/const buildVersion = '${version}'/" -i sources/commondefines.js
  '';
  postInstall = ''
    ln -s $out/lib/node_modules/common $out/lib/node_modules/Common
  '';
})

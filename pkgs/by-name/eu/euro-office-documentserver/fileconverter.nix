{
  buildNpmPackage,

  version,
  server-src,
  common,
  docservice,
}:

buildNpmPackage (finalAttrs: {
  name = "euro-office-server-FileConverter";
  src = server-src;

  sourceRoot = "${finalAttrs.src.name}/FileConverter";

  npmDepsHash = "sha256-zGLZBbQYV2z0HgQKISKVhclRKbMB8RYEX13H0mB6qJw=";

  dontNpmBuild = true;

  meta.mainProgram = "fileconverter";
  postInstall = ''
    # See also https://github.com/Euro-Office/server/pull/17
    ln -s ${common}/lib/node_modules/common $out/lib/node_modules/Common
    ln -s ${docservice}/lib/node_modules/coauthoring $out/lib/node_modules/DocService
  '';
})

{
  buildNpmPackage,
  pkg-config,
  vips,

  version,
  server-src,
  common,
}:

buildNpmPackage (finalAttrs: {
  name = "euro-office-server-DocService";
  src = server-src;
  sourceRoot = "${finalAttrs.src.name}/DocService";
  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    vips.dev
  ];
  npmDepsHash = "sha256-EKrMv1AIbdgMbXvZrqdSWP1j+s8UhEsXFdPTcJyCl1w=";
  npmFlags = [ "--loglevel=verbose" ];
  dontNpmBuild = true;
  meta.mainProgram = "docservice";
  postInstall = ''
    # it would be neater if this were a 'ln -s', but this is not possible
    # because common/sources/notificationService.js has a circular dependency
    # back on DocService
    # Upstream issue: https://github.com/Euro-Office/server/pull/17
    cp -r ${common}/lib/node_modules/common $out/lib/node_modules/Common
    ln -s $out/lib/node_modules/coauthoring $out/lib/node_modules/DocService
  '';
})

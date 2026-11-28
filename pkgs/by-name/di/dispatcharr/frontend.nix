{
  lib,
  buildNpmPackage,
  src,
  version,
}:
buildNpmPackage (finalAttrs: {
  pname = "dispatcharr-frontend";
  inherit src version;

  __structuredAttrs = true;

  sourceRoot = "${finalAttrs.src.name}/frontend";

  npmDepsHash = "sha256-yQqG1zEJSz9Dz07HSyzL3vf2aDCbXYdX6vaX2lgLVrw=";
  npmDepsFetcherVersion = 2;
  # webworkify-webpack (via mpegts.js) is a git dependency without a lockfile.
  forceGitDeps = true;
  # npm's git-dep prepare step reads these from the environment, which __structuredAttrs doesn't export.
  postPatch = "export forceGitDeps stdenv";
  makeCacheWritable = true;

  installPhase = ''
    runHook preInstall
    cp -r dist $out
    runHook postInstall
  '';

  meta = {
    description = "Web frontend for Dispatcharr";
    homepage = "https://github.com/Dispatcharr/Dispatcharr";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ mistyttm ];
    platforms = lib.platforms.all;
  };
})

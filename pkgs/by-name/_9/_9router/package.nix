{
  lib,
  buildNpmPackage,
  fetchzip,
  nix-update-script,
}:
buildNpmPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "9router";
  version = "0.4.18";

  src = fetchzip {
    url = "https://registry.npmjs.org/9router/-/9router-${finalAttrs.version}.tgz";
    hash = "sha256-xgsBgRR6zEsvNRFDWZIdmbr13M8sbZxnzLbrrKVBUTA=";
  };

  npmDepsHash = "sha256-jSPltIV+3gSVMSHtZh8tWhLbLZrxLLHqbRUG3jt2Tds=";

  # npm tarball doesn't ship a lock file; vendor a generated one.
  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  # The tarball ships a prebuilt Next.js standalone bundle under app/.
  dontNpmBuild = true;

  # Skip the bundled postinstall hook that tries to rebuild better-sqlite3
  # via `npm rebuild --build-from-source`, which requires network access.
  npmFlags = [ "--ignore-scripts" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Local AI gateway routing requests across multiple AI providers";
    homepage = "https://github.com/decolua/9router";
    downloadPage = "https://www.npmjs.com/package/9router";
    changelog = "https://github.com/decolua/9router/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ imcvampire ];
    mainProgram = "9router";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
  };
})

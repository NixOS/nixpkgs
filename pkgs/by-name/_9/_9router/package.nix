{
  lib,
  buildNpmPackage,
  fetchzip,
  nix-update-script,
  nodejs,
}:
buildNpmPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "9router";
  version = "0.5.99";

  src = fetchzip {
    url = "https://registry.npmjs.org/9router/-/9router-${finalAttrs.version}.tgz";
    hash = "sha256-uz1EiuxtYbWANgMsYO8VdDJVtiMyiJPCScLOOkYhNjQ=";
  };

  npmDepsHash = "sha256-R3RFTB7Trm75fbVsCtFo+wb/jRTrIG4ZC5kKDQdQHKo=";

  postPatch = ''
    # devDependencies only drive the upstream bundling step, which the tarball
    # has already run, and would pull in esbuild binaries for every platform.
    ${lib.getExe' nodejs "node"} --eval '
      const pkg = require("./package.json");
      delete pkg.devDependencies;
      require("fs").writeFileSync("package.json", JSON.stringify(pkg, null, 2));
    '

    # npm tarball doesn't ship a lock file; vendor a generated one.
    cp ${./package-lock.json} package-lock.json
  '';

  # The tarball ships a prebuilt Next.js standalone bundle under app/.
  dontNpmBuild = true;

  # Skip the bundled postinstall hook, which downloads better-sqlite3, sql.js
  # and systray2 into $HOME and so requires network access.
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

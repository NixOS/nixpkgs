{
  lib,
  buildNpmPackage,
  fetchurl,
  versionCheckHook,
}:

let
  source = lib.importJSON ./source.json;
in
buildNpmPackage (finalAttrs: {
  pname = "mongosh";
  version = source.version;

  src = fetchurl {
    url = "https://registry.npmjs.org/mongosh/-/${source.filename}";
    hash = source.integrity;
  };

  postPatch = ''
    ln -s ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = source.deps;

  makeCacheWritable = true;
  dontNpmBuild = true;
  npmFlags = [ "--omit=optional" ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru = {
    updateScript = ./update.sh;
  };

  meta = {
    homepage = "https://www.mongodb.com/try/download/shell";
    description = "MongoDB Shell";
    changelog = "https://www.mongodb.com/docs/mongodb-shell/changelog/#v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ aaronjheng ];
    license = lib.licenses.asl20;
    mainProgram = "mongosh";
  };
})

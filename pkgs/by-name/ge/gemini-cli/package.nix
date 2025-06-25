{
  lib,
  buildNpmPackage,
  fetchzip,
  versionCheckHook,
}:

buildNpmPackage (finalAttrs: {
  pname = "gemini-cli";
  version = "0.1.3";

  src = fetchzip {
    url = "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-${finalAttrs.version}.tgz";
    hash = "sha256-s4MYclb67Zy/I+SMy/LUl1lCG9HC5eoz1mE76wpGRbY=";
  };

  npmDepsHash = "sha256-eTuv97RuhKpG1JIbiRf84dDW8l3Wcj3Otmym1q0PiEo=";

  makeCacheWritable = true;
  npmFlags = [ "--legacy-peer-deps" ];

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  # Skip the upstream "build" step since the published tarball already
  # contains transpiled sources in "dist".
  dontNpmBuild = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "An open-source AI agent that brings Gemini directly into your terminal";
    homepage = "https://github.com/google-gemini/gemini-cli";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ qweered ];
    mainProgram = "gemini";
  };
})

{
  lib,
  buildNpmPackage,
  src,
  version,
}:

buildNpmPackage {
  inherit src version;
  pname = "photoprism-frontend";

  postPatch = ''
    cd frontend
  '';

  npmDepsHash = "sha256-IC92WESUAp+P0MbFasCTwpo0GcGoTfO8IkLbHfnrnNY=";

  # Some dependencies are fetched from git repositories
  forceGitDeps = true;
  makeCacheWritable = true;

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r ../assets $out/

    runHook postInstall
  '';

  meta = {
    homepage = "https://photoprism.app";
    description = "Photoprism's frontend";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ benesim ];
  };
}

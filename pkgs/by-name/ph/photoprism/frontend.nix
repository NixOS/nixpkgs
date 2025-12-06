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

  npmDepsHash = "sha256-RjPTtIm1BhyeQLUN9mWI+sXakNju4up0FbrdwZzkTS0=";

  # Some dependencies are fetched from git repositories
  forceGitDeps = true;
  makeCacheWritable = true;

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r ../assets $out/

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://photoprism.app";
    description = "Photoprism's frontend";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ benesim ];
  };
}

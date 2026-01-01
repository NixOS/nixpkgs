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

<<<<<<< HEAD
  npmDepsHash = "sha256-RjPTtIm1BhyeQLUN9mWI+sXakNju4up0FbrdwZzkTS0=";
=======
  npmDepsHash = "sha256-IC92WESUAp+P0MbFasCTwpo0GcGoTfO8IkLbHfnrnNY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # Some dependencies are fetched from git repositories
  forceGitDeps = true;
  makeCacheWritable = true;

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r ../assets $out/

    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
    homepage = "https://photoprism.app";
    description = "Photoprism's frontend";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ benesim ];
=======
  meta = with lib; {
    homepage = "https://photoprism.app";
    description = "Photoprism's frontend";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ benesim ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

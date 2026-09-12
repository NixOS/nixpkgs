{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "nezha-theme-admin";
  version = "2.3.6";

  src = fetchFromGitHub {
    owner = "nezhahq";
    repo = "admin-frontend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GlDL7KTznLEzvr8iXCEL8VVk7332VQAjf3bg+KfEDXM=";
  };

  # TODO: Remove after upstream fixes resolved missing.
  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-Eoc/zsVyMCVbCr+VNUPyLwoVLEy6BK+N1Vd07phHjb4=";
  npmPackFlags = [ "--ignore-scripts" ];
  npmBuildScript = "build-ignore-error";

  dontNpmInstall = true;
  installPhase = ''
    runHook preInstall

    cp -r dist $out

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Nezha monitoring admin frontend";
    homepage = "https://github.com/nezhahq/admin-frontend";
    changelog = "https://github.com/nezhahq/admin-frontend/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ moraxyc ];
  };
})

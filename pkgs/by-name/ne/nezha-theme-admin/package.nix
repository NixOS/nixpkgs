{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "nezha-theme-admin";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "nezhahq";
    repo = "admin-frontend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rLavWiGNyBjpbaFAsetmWAJvYXdzHLYawlHOUzhQ4/U=";
  };

  # TODO: Remove after upstream fixes resolved missing.
  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-6qQcsiIglaUcvdqcU6lm5MXNvfL0CvzZmC2TETWUXPI=";
  npmFlags = [ "--legacy-peer-deps" ];
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
    license = lib.licenses.wtfpl;
    maintainers = with lib.maintainers; [ moraxyc ];
  };
})

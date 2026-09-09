{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "nezha-theme-admin";
  version = "2.3.5";

  src = fetchFromGitHub {
    owner = "nezhahq";
    repo = "admin-frontend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Jrj+qMd4aRnXm27ILEVI/FkVTNLTnlD29nO1TcA0q0c=";
  };

  # TODO: Remove after upstream fixes resolved missing.
  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-d5hi9+3vyroJc6anVwUDvutk5QKnesw6qnSSQd58yMQ=";
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

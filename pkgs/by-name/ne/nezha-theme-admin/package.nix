{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "nezha-theme-admin";
  version = "1.6.4";

  src = fetchFromGitHub {
    owner = "nezhahq";
    repo = "admin-frontend";
    tag = "v${version}";
    hash = "sha256-6dWf2vC7zCVx77OdCUd9iYAACZcvkhfQdVSKQp3DGnE=";
  };

  # TODO: Switch to the bun build function once available in nixpkgs
  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-8SvD6dycFWk4+PYNNnsbUb3e3H+CTRMwMeWLfx7xppc=";

  npmPackFlags = [ "--ignore-scripts" ];

  npmBuildScript = "build-ignore-error";

  dontNpmInstall = true;
  installPhase = ''
    runHook preInstall

    cp -r dist $out

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--generate-lockfile" ]; };

  meta = {
    description = "Nezha monitoring admin frontend";
    homepage = "https://github.com/nezhahq/admin-frontend";
    changelog = "https://github.com/nezhahq/admin-frontend/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ moraxyc ];
  };
}

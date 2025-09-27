{
  lib,
  buildNpmPackage,
  fetchzip,
  nodejs_22,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "gh-copilot-cli";
  version = "0.0.327";

  nodejs = nodejs_22;

  src = fetchzip {
    url = "https://registry.npmjs.org/@github/copilot/-/copilot-${version}.tgz";
    hash = "sha256-BQhYegt4Rqnzd13BCpGD0U0/Ac9WGgryHOt3tptk06s=";
  };

  npmDepsHash = "sha256-8EDPvrVTalx4T8uTXQV5eDhTQcsCBAdPkQP6pfhKKxA=";

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--generate-lockfile" ]; };

  meta = {
    description = "GitHub Copilot CLI brings the power of Copilot coding agent directly to your terminal";
    homepage = "https://github.com/github/copilot-cli";
    downloadPage = "https://www.npmjs.com/package/@github/copilot";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      dbreyfogle
    ];
    mainProgram = "copilot";
  };
}

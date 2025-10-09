{
  lib,
  buildNpmPackage,
  fetchzip,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "github-copilot-cli";
  version = "0.0.328";

  src = fetchzip {
    url = "https://registry.npmjs.org/@github/copilot/-/copilot-${finalAttrs.version}.tgz";
    hash = "sha256-9oTaVjvwyS8KY8N5kUEiAs+l6vEd/BZ0AGJI0p9Jie0=";
  };

  npmDepsHash = "sha256-WK6t3IW4uF+MDu7Y5GRinbm8iDcYB8RhJ15GE9VBcjQ=";

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--generate-lockfile" ]; };

  meta = {
    description = "GitHub Copilot CLI brings the power of Copilot coding agent directly to your terminal";
    homepage = "https://github.com/github/copilot-cli";
    changelog = "https://github.com/github/copilot-cli/releases/tag/v${finalAttrs.version}";
    downloadPage = "https://www.npmjs.com/package/@github/copilot";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      dbreyfogle
    ];
    mainProgram = "copilot";
  };
})

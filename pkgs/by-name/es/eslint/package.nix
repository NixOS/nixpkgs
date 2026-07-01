{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  # webpack,
}:
buildNpmPackage (finalAttrs: {
  pname = "eslint";
  version = "10.6.0";

  src = fetchFromGitHub {
    owner = "eslint";
    repo = "eslint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lMdm5pKTPIhQqJjRnhvgCTLi5JxkQu5UqGtUSRHnnN8=";
  };

  # NOTE: Generating lock-file
  # npm install --package-lock-only
  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-tGeXepnZbD316nN/eGDLTcZ4hllFJiTPH2QMt/AWmZg=";
  npmInstallFlags = [ "--omit=dev" ];

  dontNpmBuild = true;
  dontNpmPrune = true;

  # Delete dangling symlinks
  preFixup = ''
    rm $out/lib/node_modules/eslint/node_modules/{eslint-config-eslint,@eslint/js}
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--generate-lockfile" ];
  };

  meta = {
    changelog = "https://github.com/eslint/eslint/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "Find and fix problems in your JavaScript code";
    homepage = "https://eslint.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mdaniels5757
      onny
    ];
  };
})

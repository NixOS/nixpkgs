{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  # webpack,
}:
buildNpmPackage (finalAttrs: {
  pname = "eslint";
  version = "10.12.0";

  src = fetchFromGitHub {
    owner = "eslint";
    repo = "eslint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-H2oa8Tl1xySDqFeNobY2I/D4HjMRf78UJQ9/pjhNLf8=";
  };

  # NOTE: Generating lock-file
  # npm install --package-lock-only
  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-ppapMvDbmidYU1qZqEaiNru0nfTZA20Vr9snRYkVwRU=";
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

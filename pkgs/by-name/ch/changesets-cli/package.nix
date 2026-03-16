{
  fetchFromGitHub,
  fetchYarnDeps,
  lib,
  nix-update-script,
  nodejs,
  stdenv,
  versionCheckHook,
  yarnBuildHook,
  yarnConfigHook,
  yarnInstallHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "changesets-cli";
  version = "2.30.0";

  src = fetchFromGitHub {
    owner = "changesets";
    repo = "changesets";
    tag = "@changesets/cli@${finalAttrs.version}";
    hash = "sha256-e8tzFRHLKAV/NZ2zrocU4SYZGag9ccUmNkIbLeomdEs=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-QvCMzUveMNrGwwVR48ZhNRP60giqqnkhg3pu8upiiBc=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    nodejs
  ];

  buildInputs = [ nodejs ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  __structuredAttrs = true;
  doInstallCheck = true;
  strictDeps = true;
  yarnKeepDevDeps = true; # Does not run otherwise

  # Don't ignore the dist/ files.
  # If we don't do this, yarn doesn't pack them during yarnInstallHook.
  postPatch = ''
    substituteInPlace .gitignore --replace-fail "dist/" ""
  '';

  postInstall = ''
    mkdir $out/bin
    ln -srL $out/lib/node_modules/@changesets/repository/node_modules/.bin/changeset $out/bin/changeset
  '';

  preFixup = ''
    # Although we can't remove all dependencies that yarn thinks are
    # dev dependencies easily, because some are actually required at runtime,
    # we can remove some of the largest ones.
    rm -rf $out/lib/node_modules/@changesets/repository/node_modules/{typescript,@types,*eslint*,*rollup}

    # Delete all non-runtime subpackages of babel
    find $out/lib/node_modules/@changesets/repository/node_modules/@babel -mindepth 1 -maxdepth 1 ! -name runtime -type d -exec rm -rf {} +

    # None of these symlinks are needed, and some are broken
    find "$out/lib/node_modules" -type d -name '.bin' -exec rm -rf {} +
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "@changesets/cli@([\\d.]*)"
      ];
    };
  };

  meta = {
    changelog = "https://github.com/changesets/changesets/blob/${finalAttrs.src.tag}/packages/cli/CHANGELOG.md";
    description = "Versioning and changelog manager with a focus on monorepos";
    homepage = "https://github.com/changesets/changesets";
    mainProgram = "changeset";
    maintainers = with lib.maintainers; [ mdaniels5757 ];
    license = lib.licenses.mit;
  };
})

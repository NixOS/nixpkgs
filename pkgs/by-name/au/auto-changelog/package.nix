{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  jq,
  git,
  versionCheckHook,
  nix-update-script,
}:
buildNpmPackage (finalAttrs: {
  pname = "auto-changelog";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "cookpete";
    repo = "auto-changelog";
    tag = "v${finalAttrs.version}";
    hash = "sha256-STW2iYn2/yJDU0lLDgvaNV/GM8+BzyYCt8bHYUc3AnM=";
  };

  # upstream doesn't ship a lockfile, the vendored one only covers runtime deps
  postPatch = ''
    cp ${./package-lock.json} package-lock.json
    ${lib.getExe jq} 'del(.devDependencies)' package.json > package.json.tmp
    mv package.json.tmp package.json
  '';

  npmDepsHash = "sha256-McMDjN+O5ds2XelNP3m8nBfu7ffJGXJmc5Omv280TWY=";

  dontNpmBuild = true;
  dontNpmPrune = true;

  npmPackFlags = [ "--ignore-scripts" ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    git
    versionCheckHook
  ];

  postInstallCheck = ''
    export HOME=$TMPDIR
    repo=$(mktemp -d)
    git -C "$repo" init -q
    git -C "$repo" -c user.name=nix -c user.email=nix@localhost commit -q --allow-empty -m init
    git -C "$repo" tag v0.1.0
    (cd "$repo" && $out/bin/auto-changelog --stdout) | grep -q 'v0.1.0'
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command line tool for generating a changelog from git tags and commit history";
    homepage = "https://github.com/cookpete/auto-changelog";
    changelog = "https://github.com/cookpete/auto-changelog/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "auto-changelog";
    maintainers = [ ];
  };
})

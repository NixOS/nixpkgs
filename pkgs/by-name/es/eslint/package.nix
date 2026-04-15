{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:
buildNpmPackage rec {
  pname = "eslint";
  version = "10.2.0";

  src = fetchFromGitHub {
    owner = "eslint";
    repo = "eslint";
    tag = "v${version}";
    hash = "sha256-JsfiBU+BiqiBAIc4DwxXYl/wtBoM9bQntiem1+vi+/s=";
  };

  # NOTE: Generating lock-file
  # arch = [ x64 arm64 ]
  # platform = [ darwin linux]
  # npm install --package-lock-only --arch=<arch> --platform=<os>
  # darwin seems to generate a cross platform compatible lockfile
  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-qpxHGNBRWN3hys5R+zJR870xIoN5VL6U3dUnKrIH0go=";
  npmInstallFlags = [ "--omit=dev" ];

  dontNpmBuild = true;
  dontNpmPrune = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--generate-lockfile" ];
  };

  meta = {
    changelog = "https://github.com/eslint/eslint/blob/${src.tag}/CHANGELOG.md";
    description = "Find and fix problems in your JavaScript code";
    homepage = "https://eslint.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mdaniels5757
      onny
    ];
  };
}

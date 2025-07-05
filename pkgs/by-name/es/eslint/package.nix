{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:
buildNpmPackage rec {
  pname = "eslint";
  version = "9.30.1";

  src = fetchFromGitHub {
    owner = "eslint";
    repo = "eslint";
    tag = "v${version}";
    hash = "sha256-IMML65KsmFLdTniciHWiw5ao0hSwILbHvz/Zx72+Mi8=";
  };

  # NOTE: Generating lock-file
  # arch = [ x64 arm64 ]
  # platform = [ darwin linux]
  # npm install --package-lock-only --arch=<arch> --platform=<os>
  # darwin seems to generate a cross platform compatible lockfile
  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-EurssIJmb6g7CmsYkUqtEdyDfvCs4Sc3VO6/4jTeP5Y=";
  npmInstallFlags = [ "--omit=dev" ];

  dontNpmBuild = true;
  dontNpmPrune = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--generate-lockfile" ];
  };

  meta = {
    description = "Find and fix problems in your JavaScript code";
    homepage = "https://eslint.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mdaniels5757
      onny
    ];
  };
}

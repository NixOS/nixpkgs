{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  stdenv,
}:
buildNpmPackage rec {
  pname = "eslint";
  version = "9.39.1";

  src = fetchFromGitHub {
    owner = "eslint";
    repo = "eslint";
    tag = "v${version}";
    hash = "sha256-++79Xcjbew56sglX9IMwLDNmbBeHzW1+yvt51ID9/4s=";
  };

  # NOTE: Generating lock-file
  # arch = [ x64 arm64 ]
  # platform = [ darwin linux]
  # npm install --package-lock-only --arch=<arch> --platform=<os>
  # darwin seems to generate a cross platform compatible lockfile
  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-ImYxBeVgfkTxU2tvSCWgWgpECsIkGiXWrx+RZKwwYxY=";
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
    maintainers = [ lib.maintainers.onny ];
  };
}

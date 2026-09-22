{
  lib,
  fetchFromGitHub,
  python3,
  runCommand,
  versionCheckHook,

  # passthru
  octodns,
}:
let
  # Export `python` with `octodns` as a module for `octodns-providers`.
  python = python3.override {
    self = python;
    packageOverrides = final: prev: {
      octodns = final.toPythonModule octodns;
    };
  };
  python3Packages = python.pkgs;
in
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "octodns";
  version = "1.22.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "octodns";
    repo = "octodns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-50GxzNlYijwg+XOiXOMBpf7W2NCoiDIk7SVEig9EaXY=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    dnspython
    fqdn
    idna
    natsort
    python-dateutil
    pyyaml
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    jsonschema
  ];

  pythonImportsCheck = [ "octodns" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    providers = lib.recurseIntoAttrs (
      lib.packagesFromDirectoryRecursive {
        inherit (python3Packages) callPackage;
        directory = ./providers;
      }
    );

    withProviders =
      ps:
      let
        pyEnv = python.withPackages ps;
      in
      runCommand "octodns-with-providers" { } ''
        mkdir -p $out/bin
        ln -st $out/bin ${pyEnv}/bin/octodns-*
      '';
  };

  meta = {
    description = "Tools for managing DNS across multiple providers";
    homepage = "https://github.com/octodns/octodns";
    changelog = "https://github.com/octodns/octodns/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "octodns-sync";
    teams = [ lib.teams.octodns ];
  };
})

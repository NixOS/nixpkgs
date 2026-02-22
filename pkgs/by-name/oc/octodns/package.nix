{
  lib,
  fetchFromGitHub,
  python3,
  runCommand,

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
  version = "1.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "octodns";
    repo = "octodns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wVUMj47Ex2GrCytV0JhmXUKuIwAw59X7+ce/0LhwmkE=";
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
  ];

  pythonImportsCheck = [ "octodns" ];

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
    teams = [ lib.teams.octodns ];
  };
})

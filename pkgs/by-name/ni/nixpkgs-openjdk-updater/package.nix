{
  lib,
  python3Packages,
  ruff,
  pyright,
  fetchFromGitHub,
  nixpkgs-openjdk-updater,
}:

python3Packages.buildPythonApplication {
  pname = "nixpkgs-openjdk-updater";
  version = "0.1.0";
  format = "pyproject";

  src = ./nixpkgs-openjdk-updater;

  build-system = [ python3Packages.hatchling ];

  dependencies = [
    python3Packages.pydantic
    python3Packages.pygithub
  ];

  nativeCheckInputs = [
    ruff
    pyright
    python3Packages.pytestCheckHook
  ];

  preCheck = ''
    ruff format --check
    ruff check
    pyright
  '';

  postCheck = ''
    $out/bin/nixpkgs-openjdk-updater --help >/dev/null
  '';

  passthru.openjdkSource =
    {
      sourceFile,
      featureVersionPrefix,
    }:
    let
      # TODO: Tighten up after update scripts are run.
      src = fetchFromGitHub (lib.importJSON sourceFile);
    in
    {
      inherit src;

      updateScript = {
        command = [
          (lib.getExe nixpkgs-openjdk-updater)

          "--source-file"
          sourceFile

          "--owner"
          src.owner

          "--repo"
          src.repo

          "--feature-version-prefix"
          featureVersionPrefix
        ];

        supportedFeatures = [ "silent" ];
      };
    };

  meta = {
    description = "Updater for Nixpkgs OpenJDK packages";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    maintainers = [ lib.maintainers.emily ];
    mainProgram = "nixpkgs-openjdk-updater";
  };
}

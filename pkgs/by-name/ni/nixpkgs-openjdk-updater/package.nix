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
      sourceInfo = lib.importJSON sourceFile;
    in
    {
      src = fetchFromGitHub {
        inherit (sourceInfo)
          owner
          repo
          rev
          hash
          ;
      };

      updateScript = {
        command = [
          (lib.getExe nixpkgs-openjdk-updater)

          "--source-file"
          sourceFile

          "--owner"
          sourceInfo.owner

          "--repo"
          sourceInfo.repo

          "--feature-version-prefix"
          featureVersionPrefix
        ];

        supportedFeatures = [ "silent" ];
      };
    };

  meta = with lib; {
    description = "Updater for Nixpkgs OpenJDK packages";
    license = licenses.mit;
    sourceProvenance = [ sourceTypes.fromSource ];
    maintainers = [ maintainers.emily ];
    mainProgram = "nixpkgs-openjdk-updater";
  };
}

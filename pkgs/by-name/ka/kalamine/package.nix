{
  lib,

  # for passthrus
  callPackage,
  runCommand,
  writeText,
  writers,

  python3Packages,

  fetchFromGitHub,

  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "kalamine";
  version = "0.40";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "OneDeadKey";
    repo = "kalamine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9R8N5p+VNuiqTl3a0SSmJEVg3Ol76nROf43GsdOdJL8=";
  };

  patches = [
    # Ensure that all files at generated at epoch.
    ./time.patch
  ];

  build-system = [
    python3Packages.hatchling
  ];

  dependencies = with python3Packages; [
    click
    livereload
    lxml
    progress
    pyyaml
    tomli
  ];

  pythonImportsCheck = [ "kalamine" ];

  # https://github.com/OneDeadKey/kalamine/blob/a9724bf6e93a34c740f9349b8811b2e51cc62c41/Makefile#L39
  preCheck = ''
    python -m kalamine.cli build layouts/*.toml
  '';

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgramArg = "version";
  versionCheckKeepEnvironment = [ "HOME" ];

  # kalamine can be used as a `nativeBuildInputs` to produce keymaps
  # A minimal example use is the following:
  # ```nix
  # stdenvNoCC.mkDerivation (finalAttrs: {
  #   name = "my-layout";
  #   src = ...; # can be a toml file or a directory containing toml files or something else
  #
  #   # In the else case above, set the following if `src` does not contain the keymap(s) at its root
  #   sourceRoot = "${finalAttrs.src.name}/path/to/keymaps";
  #
  #   __structuredAttrs = true; # important for the correct expansion of arguments below.
  #   kalamineBuildArgs = [ "--angle-mod" ]; # cf. kalamine build docs. Empty if unset.
  #
  #   nativeBuildInputs = [ kalamine ];
  # })
  # ```
  #
  # If kalamine needs to be a `nativeBuildInput`, but you don't need the setup hook, set `dontUseKalamineBuild = true;`
  setupHooks = ./setup-hook.sh;

  passthru = {
    tests = import ./tests.nix {
      inherit
        lib
        callPackage
        runCommand
        ;
      kalamine = finalAttrs.finalPackage;
    };

    # Example usage:
    # `pkgs.kalamine.fromDir "${myBigRepo}/keymaps" { pname = "myKeymapsSet"; version = "0.0.1"; }`
    # This is a shorthand function for use in configurations; use the setup hook if you need a proper derivation.
    fromDir = import ./fromDir.nix {
      inherit callPackage lib;
      kalamine = finalAttrs.finalPackage;
    };

    # Example usage:
    # `pkgs.kalamine.fromLayout ./myLayout.toml {}`
    # Some attributes are inferred from the kalamine TOML spec and are overridable in the last attrset.
    # Refer to the function definition for documentation.
    # This is a shorthand function for use in configurations; use the setup hook if you need a proper derivation.
    fromLayout = import ./fromLayout.nix {
      inherit writeText writers lib;
      inherit (finalAttrs.passthru) fromDir;
    };
  };

  meta = {
    description = "Keyboard Layout Maker";
    homepage = "https://github.com/OneDeadKey/kalamine/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xaltsc ];
    mainProgram = "kalamine";
  };
})

{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "linecast";
  version = "2.2.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ashuttl";
    repo = "linecast";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NjuA/WNUi+4NcPiFr3R0Nl163IHQwaMHfK71QTSAYsk=";
  };

  build-system = [
    python3Packages.hatchling
  ];

  dependencies = with python3Packages; [
    truststore
    tzdata
  ];

  pythonImportsCheck = [
    "linecast"
  ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "linecast";
    description = "Weather, tides, the sun, the moon, and maps, in your terminal. The Old Farmer's Almanac meets Minitel";
    longDescription = ''
      linecast turns free public data into six live, mouse-friendly terminal apps.
      It is pure Python, has no dependencies on macOS or Linux (and just two on Windows),
      tries to match your terminal theme (on macOS and Linux), and needs no account or API key.
    '';
    homepage = "https://github.com/ashuttl/linecast";
    downloadPage = "https://github.com/ashuttl/linecast/releases/tag/v${finalAttrs.version}";
    changelog = "https://github.com/ashuttl/linecast/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    identifiers = {
      cpeParts = {
        vendor = "ashuttl";
        product = "linecast";
        version = finalAttrs.version;
      };
      purlParts = {
        type = "github";
        namespace = "ashuttl";
        name = "linecast";
        version = finalAttrs.version;
      };
    };
    maintainers = with lib.maintainers; [
      KristijanZic
      ashuttl
    ];
  };
})

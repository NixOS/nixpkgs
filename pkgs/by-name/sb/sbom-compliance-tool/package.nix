{
  lib,
  python3Packages,
  fetchFromGitea,
  cyclonedx-python,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "sbom-compliance-tool";
  version = "0.0.11";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "software-compliance-org";
    repo = "sbom-compliance-tool";
    tag = finalAttrs.version;
    hash = "sha256-6ZaHY1EKjJ78PrCov0wenj5doc93Ot9/yN4hEaagSmE=";
  };

  postPatch = ''
    # https://setuptools.pypa.io/en/latest/userguide/package_discovery.html#finding-namespace-packages
    substituteInPlace setup.py \
      --replace-fail \
        "packages=['sbom_compliance_tool']" \
        "packages=setuptools.find_namespace_packages(include=['sbom_compliance_tool*'])"
  '';

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    cyclonedx-python
    foss-flame
    licomp
    licomp-toolkit
    lookup-license
  ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [
    "sbom_compliance_tool"
    "sbom_compliance_tool.reader"
  ];

  meta = {
    description = "Tool to assist your compliance work with SBoM";
    homepage = "https://codeberg.org/software-compliance-org/sbom-compliance-tool";
    mainProgram = "sbom_compliance_tool";
    license = with lib.licenses; [
      gpl3Only
      gpl3Plus
    ];
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})

{
  lib,
  python3Packages,
  fetchFromGitLab,
  buildstream,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "buildstream-sbom";
  version = "1.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitLab {
    owner = "buildstream";
    repo = "buildstream-sbom";
    tag = finalAttrs.version;
    hash = "sha256-Eo9aoJFdYFQWE6K/C44Q45XUDH0R8I+Hxqu0EHkbIbk=";
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    buildstream
  ];

  propagatedBuildInputs = [
    python3Packages.pyyaml
  ];

  meta = {
    changelog = "https://gitlab.com/buildstream/buildstream-sbom/-/blob/${finalAttrs.src.tag}/CHANGES.rst";
    description = "Tool to generate a SPDX 2.3 SBoM of a BuildStream element and its dependencies.";
    homepage = "https://gitlab.com/BuildStream/buildstream-sbom";
    license = lib.licenses.asl20;
    longDescription = "This tool can be used to produce an SBoM (Software Bill of Materials) describing a BuildStream element and its dependencies.";
    mainProgram = "buildstream-sbom";
    maintainers = with lib.maintainers; [ shymega ];
    platforms = lib.platforms.linux;
  };
})

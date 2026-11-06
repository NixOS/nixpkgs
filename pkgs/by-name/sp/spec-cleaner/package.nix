{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "spec-cleaner";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rpm-software-management";
    repo = "spec-cleaner";
    tag = "spec-cleaner-${finalAttrs.version}";
    hash = "sha256-sCFyK6dyOXs3eZshUglSnjyqiH78Ed3ijAFzthSFZ3E=";
  };

  build-system = [ python3Packages.setuptools ];

  postPatch = ''
    substituteInPlace obs/clean_spec_file obs/format_spec_file \
      --replace-fail /usr/bin/spec-cleaner "$out/bin/spec-cleaner"
  '';

  dependencies = [ python3Packages.python-rpm-spec ];

  nativeCheckInputs = [ python3Packages.pytestCheckHook ];

  # Override upstream coverage and parallel execution options.
  pytestFlags = [ "-o=addopts=" ];

  disabledTestMarks = [ "webtest" ];

  disabledTests = [
    # Probes remote HTTPS URLs but is not marked as a webtest upstream.
    "test_normal_outputs[source_https.spec]"
  ];

  pythonImportsCheck = [ "spec_cleaner" ];

  meta = {
    description = "Tool for cleaning RPM spec files according to the openSUSE style guide";
    homepage = "https://github.com/rpm-software-management/spec-cleaner";
    changelog = "https://github.com/rpm-software-management/spec-cleaner/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ peti ];
    mainProgram = "spec-cleaner";
  };
})

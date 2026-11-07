{
  lib,
  buildPythonPackage,
  torchlensmaker,

  # build-system
  uv-build,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "tlmviewer";
  pyproject = true;
  __structuredAttrs = true;

  inherit (torchlensmaker)
    version
    src
    ;

  sourceRoot = "${finalAttrs.src.name}/tlmviewer-python";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.10.9,<0.11.0" "uv_build"
  '';

  build-system = [
    uv-build
  ];

  pythonImportsCheck = [
    "tlmviewer"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Require connection to tlmserver (http://127.0.0.1:8765/push)
    # TODO: package tlmserver?
    "test_push_raises_connection_refused_when_unreachable"
    "test_allow_fail_silences_http_error"
    "test_allow_fail_not_set_still_raises"
  ];

  meta = {
    description = "3D optical scene viewer for torchlensmaker";

    inherit (torchlensmaker.meta)
      homepage
      changelog
      license
      maintainers
      teams
      ;
  };
})

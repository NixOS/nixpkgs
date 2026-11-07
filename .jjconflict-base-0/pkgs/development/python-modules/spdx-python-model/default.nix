{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchurl,
  hatch-build-scripts,
  hatchling,
  nix-update-script,
  pytestCheckHook,
  runCommandLocal,
  shacl2code,
}:

let
  spdxModel = fetchurl {
    url = "https://raw.githubusercontent.com/spdx/spdx-spec/gh-pages/3.0.1/rdf/spdx-model.ttl";
    hash = "sha256-MOu0ry1wqYCQRO9G9EzD3FElIm1w+BilDtLh1fQExZM=";
  };

  spdxJsonLdAnnotations = fetchurl {
    url = "https://raw.githubusercontent.com/spdx/spdx-spec/gh-pages/3.0.1/rdf/jsonld-annotations.ttl";
    hash = "sha256-xqVLUSMOsr87MTAlRq8gHzA+C3kxwdtATX9bcrb4Y+Y=";
  };

  spdxContext = fetchurl {
    url = "https://raw.githubusercontent.com/spdx/spdx-spec/gh-pages/3.0.1/rdf/spdx-context.jsonld";
    hash = "sha256-xysJKPCUyD5cEneE7bHryir3ShBPyswAfDMrI8vHiL0=";
  };

  spdxData = runCommandLocal "spdx-python-model-spdx-data" { } ''
    mkdir -p "$out/3.0.1"
    ln -s ${spdxModel} "$out/3.0.1/spdx-model.ttl"
    ln -s ${spdxJsonLdAnnotations} "$out/3.0.1/spdx-json-serialize-annotations.ttl"
    ln -s ${spdxContext} "$out/3.0.1/spdx-context.jsonld"
  '';
in
buildPythonPackage (finalAttrs: {
  pname = "spdx-python-model";
  version = "0.0.6";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "spdx";
    repo = "spdx-python-model";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cf9fNjyeVEVeF41zLS29wB4eJKSam2O0pHZC1JpiLvI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"shacl2code == 1.1.0",' '"shacl2code",'
  '';

  build-system = [
    hatch-build-scripts
    hatchling
    shacl2code
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  preBuild = ''
    export SHACL2CODE_SPDX_DIR="${spdxData}"
  '';

  pythonImportsCheck = [ "spdx_python_model" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generated Python code for SPDX Spec version 3";
    homepage = "https://github.com/spdx/spdx-python-model";
    changelog = "https://github.com/spdx/spdx-python-model/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})

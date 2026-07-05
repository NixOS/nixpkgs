{
  lib,
  esphome,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (
  finalAttrs:
  let
    dependencies = with python3Packages; [
      (python3Packages.toPythonModule esphome)
      esphome-device-builder-frontend
      aiohttp
      aiohttp-asyncmdnsresolver
      colorlog
      cryptography
      fnv-hash-fast
      ifaddr
      mashumaro
      orjson
      pyyaml
      ruamel-yaml
      voluptuous
      zeroconf
    ];
  in
  {
    pname = "esphome-device-builder";
    version = "1.0.29";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "esphome";
      repo = "device-builder";
      tag = finalAttrs.version;
      hash = "sha256-23Uj2n9SlQ4FTqRky8IRg3OE04MxVcWB1z6DLfbFQ8E=";
    };

    build-system = with python3Packages; [ setuptools ];

    pythonRelaxDeps = [ "zeroconf" ];

    postPatch = ''
      substituteInPlace pyproject.toml \
        --replace-fail "version = \"0.0.0\"" "version = \"${finalAttrs.version}\""
    '';

    inherit dependencies;

    passthru = {
      pythonPath = python3Packages.makePythonPath dependencies;
    };

    __structuredAttrs = true;

    meta = {
      changelog = "https://github.com/esphome/esphome-device-builder/releases/tag/${finalAttrs.src.tag}";
      description = "ESPHome Device Builder Dashboard";
      homepage = "https://esphome.io/";
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [ DavidvtWout ];
      mainProgram = "esphome-device-builder";
    };
  }
)

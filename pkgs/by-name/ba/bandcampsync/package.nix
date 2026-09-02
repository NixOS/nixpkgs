{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "bandcampsync";
  version = "0.8.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "meeb";
    repo = "bandcampsync";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j370Kn95CQuGjwOoFMXNNQZ5odlR/0uiw02hN/UVAb8=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    beautifulsoup4
    curl-cffi
  ];

  pythonImportsCheck = [ "bandcampsync" ];

  meta = {
    description = "Download your Bandcamp purchases automatically";
    homepage = "https://github.com/meeb/bandcampsync";
    changelog = "https://github.com/meeb/bandcampsync/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.haylin ];
    mainProgram = "bandcampsync";
  };
})

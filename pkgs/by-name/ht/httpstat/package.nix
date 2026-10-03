{
  lib,
  fetchFromGitHub,
  curl,
  python3Packages,
  glibcLocales,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "httpstat";
  version = "1.3.2";
  pyproject = true;
  src = fetchFromGitHub {
    owner = "reorx";
    repo = "httpstat";
    rev = finalAttrs.version;
    hash = "sha256-dOHFLw8suvpuZkcKEzq5HktMYBGE7+vtTD609TkAFfw=";
  };

  # python3.8+ changed AST parsing, so until upstream builds against newer versions this has to do
  postPatch = ''
    substituteInPlace setup.py --replace-fail \
      "version=get_version()" \
      "version='${finalAttrs.version}'"
  '';

  build-system = with python3Packages; [ setuptools ];

  buildInputs = [ glibcLocales ];
  runtimeDeps = [ curl ];

  env.LC_ALL = "en_US.UTF-8";

  meta = {
    description = "Curl statistics made simple";
    mainProgram = "httpstat";
    homepage = "https://github.com/reorx/httpstat";
    license = lib.licenses.mit;
  };
})

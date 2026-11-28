{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "sslstrip";
  version = "5.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "L1ghtn1ng";
    repo = "sslstrip";
    tag = finalAttrs.version;
    hash = "sha256-FB3xebfJS+7gS9aO0+dLHXHofKrTkeILqPIRNq/66RM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build==0.12.5" "uv_build"
  '';

  pythonRelaxDeps = [ "brotli" ];

  build-system = with python3.pkgs; [ uv-build ];

  dependencies =
    with python3.pkgs;
    [
      brotli
      twisted
    ]
    ++ twisted.optional-dependencies.tls;

  nativeCheckInputs = with python3.pkgs; [ pytestCheckHook ];

  pythonImportsCheck = [ "sslstrip" ];

  meta = {
    description = "Tool for exploiting SSL stripping attacks";
    homepage = "https://github.com/L1ghtn1ng/sslstrip";
    changelog = "https://github.com/L1ghtn1ng/sslstrip/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "sslstrip";
  };
})

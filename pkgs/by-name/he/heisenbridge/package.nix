{
  lib,
  fetchFromGitHub,
  nix-update-script,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "heisenbridge";
  version = "1.15.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hifi";
    repo = "heisenbridge";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-Aan3dtixy1xT9kPU/XxgbUvri9NS/WKiO/atmpPY/m8=";
  };

  postPatch = ''
    echo "${finalAttrs.version}" > heisenbridge/version.txt
  '';

  build-system = with python3.pkgs; [
    setuptools
  ];

  pythonRelaxDeps = [
    "irc"
  ];

  dependencies = with python3.pkgs; [
    irc
    ruamel-yaml
    mautrix
    python-socks
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Bouncer-style Matrix-IRC bridge";
    homepage = "https://github.com/hifi/heisenbridge";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sumnerevans ];
    mainProgram = "heisenbridge";
  };
})

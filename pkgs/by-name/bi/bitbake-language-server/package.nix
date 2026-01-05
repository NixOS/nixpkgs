{
  lib,
  nix-update-script,
  python3,
  oelint-adv,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "bitbake-language-server";
  version = "0.0.15";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Freed-Wu";
    repo = "bitbake-language-server";
    tag = version;
    hash = "sha256-NLDQ2P5peweugkoNYskpCyCEgBwVFA7RTs8+NvH8fj8=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools-scm
    setuptools-generate
  ];

  propagatedBuildInputs =
    with python3.pkgs;
    [
      pygls
    ]
    ++ [ oelint-adv ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language server for bitbake";
    mainProgram = "bitbake-language-server";
    homepage = "https://github.com/Freed-Wu/bitbake-language-server";
    changelog = "https://github.com/Freed-Wu/bitbake-language-server/releases/tag/${version}";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.otavio ];
  };
}

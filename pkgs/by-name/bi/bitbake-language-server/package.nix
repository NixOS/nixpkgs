{
  lib,
  nix-update-script,
  python3,
  oelint-adv,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "bitbake-language-server";
  version = "0.0.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Freed-Wu";
    repo = "bitbake-language-server";
    tag = finalAttrs.version;
    hash = "sha256-Huk5fpuN5bNtxH52UX2I86T5s82LXynZreZOGKFVq/w=";
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
    changelog = "https://github.com/Freed-Wu/bitbake-language-server/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.otavio ];
  };
})

{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "confy-tui";
  version = "3.0.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "phluxjr";
    repo = "confy";
    rev = "v${finalAttrs.version}";
    hash = "sha256-yhzmkIPrOckDxoB10RBX5ul/rYzVKtU6l6O1Zm69e9c=";
  };

  build-system = [
    python3Packages.hatchling
  ];

  postInstall = ''
    install -Dm644 confy.1 $out/share/man/man1/confy.1
  '';

  meta = {
    description = "config manager tui for linux/unix systems";
    homepage = "https://github.com/phluxjr/confy";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ phluxjr ];
    mainProgram = "confy";
    platforms = lib.platforms.unix;
  };
})

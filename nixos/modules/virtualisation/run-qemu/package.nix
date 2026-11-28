{
  stdenv,
  lib,
  buildPythonApplication,
  virtiofsd,
  ruff,
  setuptools,
  ty,
  makeBinaryWrapper,
  qemu,
}:

buildPythonApplication {
  pname = "run-qemu";
  version = "1.0";
  pyproject = true;

  src = ./.;

  build-system = [
    setuptools
  ];

  doCheck = true;

  nativeBuildInputs = [ makeBinaryWrapper ];
  nativeCheckInputs = [
    ruff
    ty
  ];

  checkPhase = ''
    echo -e "\x1b[32m## run ty\x1b[0m"
    ty check --error-on-warning run_qemu
    echo -e "\x1b[32m## run ruff check\x1b[0m"
    ruff check .
    echo -e "\x1b[32m## run ruff format\x1b[0m"
    ruff format --check --diff .
  '';

  postInstall = ''
    wrapProgram $out/bin/run-qemu \
      --prefix PATH : "${
        lib.makeBinPath ([ qemu ] ++ lib.optionals stdenv.hostPlatform.isLinux [ virtiofsd ])
      }"
  '';

  meta = {
    mainProgram = "run-qemu";
    platforms = lib.platforms.unix;
  };
}

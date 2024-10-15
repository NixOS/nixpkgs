{
  lib,
  python3Packages,
}:

python3Packages.buildPythonApplication {
  pname = "auto-patchelf";
  version = "0-unstable-2024-08-14";
  pyproject = false;

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./auto-patchelf.py
    ];
  };

  dependencies = with python3Packages; [
    pyelftools
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 auto-patchelf.py $out/bin/auto-patchelf

    runHook postInstall
  '';

  makeWrapperArgs = [
    "--set DEFAULT_BINTOOLS $NIX_BINTOOLS"
  ];

  meta = {
    description = "Automatically patch ELF binaries using patchelf";
    mainProgram = "auto-patchelf";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ Scrumplex ];
  };
}

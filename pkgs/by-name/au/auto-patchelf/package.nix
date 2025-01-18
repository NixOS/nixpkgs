{
  stdenv,
  python3,
  lib,
}:

let
  pythonEnv = python3.withPackages (ps: [ ps.pyelftools ]);

in
# Note: Not using python3Packages.buildPythonApplication because of dependency propagation.
stdenv.mkDerivation {
  pname = "auto-patchelf";
  version = "0-unstable-2024-08-14";

  buildInputs = [ pythonEnv ];

  src = ./source;

  buildPhase = ''
    runHook preBuild

    substituteInPlace auto-patchelf.py --replace-fail "@defaultBintools@" "$NIX_BINTOOLS"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 auto-patchelf.py $out/bin/auto-patchelf

    runHook postInstall
  '';

  meta = with lib; {
    description = "Automatically patch ELF binaries using patchelf";
    mainProgram = "auto-patchelf";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ Scrumplex ];
  };
}

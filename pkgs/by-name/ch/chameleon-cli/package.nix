{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  makeWrapper,
  python3,
  nix-update-script,
}:

let
  # https://github.com/RfidResearchGroup/ChameleonUltra/blob/main/software/script/requirements.txt
  pythonPath =
    with python3.pkgs;
    makePythonPath [
      colorama
      prompt-toolkit
      pyserial
    ];
in

stdenv.mkDerivation (finalAttrs: {
  pname = "chameleon-cli";
  version = "2.0.0-unstable-2025-04-21";

  src = fetchFromGitHub {
    owner = "RfidResearchGroup";
    repo = "ChameleonUltra";
    rev = "303d2d31e10b0b57c6181f7396706a23d54b72d7";
    sparseCheckout = [ "software" ];
    hash = "sha256-v7So6zEfoNt7wRnK+NueGeGUDep+VR6ImTmBSH36fYE=";
  };

  sourceRoot = "${finalAttrs.src.name}/software";

  patches = [
    # Fix when the dir conatains hardnested is read only
    # https://github.com/RfidResearchGroup/ChameleonUltra/pull/261
    (fetchpatch {
      url = "https://github.com/RfidResearchGroup/ChameleonUltra/commit/af8aa0146941b1e2e516b26da93739a86a083237.patch";
      hash = "sha256-+VJT1LyxZv15xJr6XRzGYYib1DfOADtcp7K4kpKuxn0=";
      stripLen = 1;
    })
  ];

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];

  cmakeFlags = [
    "-S"
    "../src"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/libexec
    cp -r ../script/* $out/libexec
    rm -r $out/libexec/tests
    rm $out/libexec/requirements.txt
    makeWrapper ${lib.getExe python3} $out/bin/chameleon-cli \
      --add-flags "$out/libexec/chameleon_cli_main.py" \
      --prefix PYTHONPATH : ${pythonPath}

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version=branch"
      "--version-regex=^v[0-9.]+$"
    ];
  };

  meta = {
    description = "Command line interface for Chameleon Ultra";
    homepage = "https://github.com/RfidResearchGroup/ChameleonUltra";
    license = lib.licenses.gpl3Only;
    mainProgram = "chameleon-cli";
    maintainers = with lib.maintainers; [ azuwis ];
  };
})

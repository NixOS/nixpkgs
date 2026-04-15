{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  makeWrapper,
  openssl,
  xz,
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
  version = "2.1.0-unstable-2026-04-06";

  src = fetchFromGitHub {
    owner = "RfidResearchGroup";
    repo = "ChameleonUltra";
    rev = "93c1e150ab17b81cec40639fea7e88b1920e2c95";
    rootDir = "software";
    hash = "sha256-5yxXmKRBNmmJgiA2E3gUmGRgPZpO/CRFlMw5YFCFUUs=";
  };

  postPatch = ''
    substituteInPlace src/CMakeLists.txt \
      --replace-fail "liblzma" "lzma" \
      --replace-fail "FetchContent_MakeAvailable(xz)" ""
  '';

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];

  buildInputs = [
    openssl
    xz
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
      "--version-regex=v(.*)"
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

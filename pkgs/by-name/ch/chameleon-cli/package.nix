{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  makeWrapper,
  xz,
  python3,
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
  version = "2.0.0-unstable-2025-08-04";

  src = fetchFromGitHub {
    owner = "RfidResearchGroup";
    repo = "ChameleonUltra";
    rev = "098e0a914b206900f7ea7ae7265486c4349ab644";
    sparseCheckout = [ "software" ];
    hash = "sha256-WKxP4jLHkTqBO+nwxhr8DRb3TzDIMlwjA4v+6txQbDo=";
  };

  sourceRoot = "${finalAttrs.src.name}/software";

  patches = [
    # Use execute_tool to simplify running hardnested tool,
    # also fix when the dir conatains hardnested is read only
    # https://github.com/RfidResearchGroup/ChameleonUltra/pull/266
    (fetchpatch {
      url = "https://github.com/RfidResearchGroup/ChameleonUltra/commit/39270fd09ee61ef0659bf3b79ffa4d2b27f3ba63.patch";
      hash = "sha256-OlHQ2cL+NFdTsSPFI9geg3dabATRjyKxGp5gGG+eDl8=";
      stripLen = 1;
    })
  ];

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

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Command line interface for Chameleon Ultra";
    homepage = "https://github.com/RfidResearchGroup/ChameleonUltra";
    license = lib.licenses.gpl3Only;
    mainProgram = "chameleon-cli";
    maintainers = with lib.maintainers; [ azuwis ];
  };
})

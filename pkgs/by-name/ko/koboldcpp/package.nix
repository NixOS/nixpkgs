{
  lib,
  fetchFromGitHub,
  stdenv,
  makeWrapper,
  python3Packages,
  tk,

  koboldLiteSupport ? true,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "koboldcpp";
  version = "1.116.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "LostRuins";
    repo = "koboldcpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jElhMxi8FyvprlSWlc0PQa0NtLvBNZXY3vF/7YKZFv4=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    makeWrapper
    python3Packages.wrapPython
  ];

  pythonInputs = builtins.attrValues { inherit (python3Packages) tkinter customtkinter packaging; };

  buildInputs = [
    tk
  ]
  ++ finalAttrs.pythonInputs;

  pythonPath = finalAttrs.pythonInputs;

  makeFlags = [
    "LLAMA_PORTABLE=1"
  ];

  buildFlags = [
    "koboldcpp_default"
    "koboldcpp_failsafe"
    "koboldcpp_noavx2"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"

    install -Dm755 koboldcpp.py "$out/bin/koboldcpp.unwrapped"
    cp *.so "$out/bin"
    cp -r embd_res "$out/bin"

    ${lib.optionalString (!koboldLiteSupport) ''
      rm "$out/bin/embd_res/kcpp_docs.embd"
      rm "$out/bin/embd_res/klite.embd"
    ''}

    runHook postInstall
  '';

  postFixup = ''
    wrapPythonProgramsIn "$out/bin" "''${pythonPath[*]}"
    makeWrapper "$out/bin/koboldcpp.unwrapped" "$out/bin/koboldcpp" \
      --prefix PATH : ${lib.makeBinPath [ tk ]}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/LostRuins/koboldcpp/releases/tag/v${finalAttrs.version}";
    description = "Way to run various GGML and GGUF models";
    homepage = "https://github.com/LostRuins/koboldcpp";
    license = with lib.licenses; [ agpl3Only ];
    mainProgram = "koboldcpp";
    maintainers = with lib.maintainers; [
      maxstrid
      FlameFlag
    ];
    platforms = lib.platforms.unix;
  };
})

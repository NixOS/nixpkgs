{
  lib,
  stdenv,
  fetchFromGitLab,
  replaceVars,
  pkg-config,
  go-md2man,
  installShellFiles,
  linenoise,
  darwin,
  lrzsz,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "picocom";
  version = "2024-07";

  src = fetchFromGitLab {
    owner = "wsakernel";
    repo = "picocom";
    rev = finalAttrs.version;
    hash = "sha256-cQoEfi75iltjeAm26NvXgfrL7d1Hm+1veQ4dVe0S1q8=";
  };

  patches = [
    ./use-system-linenoise.patch
    (replaceVars ./lrzsz-path.patch { inherit lrzsz; })
  ];

  nativeBuildInputs = [
    pkg-config
    go-md2man
    installShellFiles
  ];

  buildInputs = [
    linenoise
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.IOKit ];

  makeFlags = [
    "HISTFILE=.cache/picocom_history"
    "all"
    "doc"
  ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    install -Dm555 -t $out/bin picocom
    installManPage picocom.1
    installShellCompletion --bash bash_completion/picocom

    runHook postInstall
  '';

  meta = {
    description = "Minimal dumb-terminal emulation program";
    homepage = "https://gitlab.com/wsakernel/picocom";
    changelog = "https://gitlab.com/wsakernel/picocom/-/releases";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    mainProgram = "picocom";
  };
})

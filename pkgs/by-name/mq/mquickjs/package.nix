{
  lib,
  fetchFromGitHub,
  stdenv,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "mquickjs";
  version = "0-unstable-2026-11-09";

  src = fetchFromGitHub {
    owner = "bellard";
    repo = "mquickjs";
    rev = "4119f6819ccb5bae2d21a18a106e89522d18ad45";
    hash = "sha256-k4HTfzxSB5pcWOzJwyclo05ncP35lSKCWf6iN7sSeg4=";
  };

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "HOST_CC=${stdenv.cc.targetPrefix}cc"
  ];

  strictDeps = true;
  __structuredAttrs = true;

  enableParallelBuilding = true;

  doCheck = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 ./mqjs -t $out/bin

    runHook postInstall
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    PATH="$out/bin:$PATH"

    # Programs exit with code 1 when testing help, so grep for a string
    (mqjs --help 2>&1 || true) | grep --quiet "MicroQuickJS"

    mqjs --eval "console.log('Output from eval');" | grep --quiet "Output from eval"

    runHook postInstallCheck
  '';

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
  };

  meta = {
    homepage = "https://github.com/bellard/mquickjs";
    description = "Micro QuickJS, a JavaScript engine for microcontrollers";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
    mainProgram = "mqjs";
  };
}

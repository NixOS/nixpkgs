{
  lib,
  fetchFromGitHub,
  stdenv,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "mquickjs";
  version = "0-unstable-2025-12-27";

  src = fetchFromGitHub {
    owner = "bellard";
    repo = "mquickjs";
    rev = "0bbe1636ca003564bf6a3f6021bd728e1d722fa9";
    hash = "sha256-A4L1qHY3tY5fHQeCbPYIDJ3TdY5Bg9eTjLdhVin14dY=";
  };

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "HOST_CC=${stdenv.cc.targetPrefix}cc"
  ];

  strictDeps = true;

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

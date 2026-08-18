{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "auto-epp";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "jothi-prasath";
    repo = "auto-epp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7sI8K+7ZAdzBN/XOzYQQZ1f9t+fFo6fcXYzX6abNyQ8=";
  };

  buildInputs = [ python3 ];

  installPhase = ''
    runHook preInstall
    install -Dm555 auto-epp $out/bin/auto-epp
    runHook postInstall
  '';

  meta = {
    mainProgram = "auto-epp";
    homepage = "https://github.com/jothi-prasath/auto-epp";
    description = "Energy performance preference tuner for AMD processors when amd_pstate=active";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.lamarios ];
  };
})

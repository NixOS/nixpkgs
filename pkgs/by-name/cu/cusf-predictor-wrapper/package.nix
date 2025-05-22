{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  glib,
  installShellFiles,
}:
stdenv.mkDerivation {
  pname = "cusf_predictor_wrapper";
  version = "0-unstable-2025-03-04";

  src = fetchFromGitHub {
    owner = "darksidelemm";
    repo = "cusf_predictor_wrapper";
    rev = "f4352834a037e3e2bf01a3fd7d5a25aa482e27c6";
    hash = "sha256-C8/5x8tim6s0hWgCC7LpN1hesdVME5kpQFqDTEyXHtg=";
  };

  sourceRoot = "source/src";

  nativeBuildInputs = [
    cmake
    pkg-config
    glib
    installShellFiles
  ];

  installPhase = ''
    runHook preInstall

    mv pred cusf_predictor_wrapper
    installBin cusf_predictor_wrapper

    runHook postInstall
  '';

  meta = {
    description = "CUSF standalone predictor";
    homepage = "https://github.com/darksidelemm/cusf_predictor_wrapper";
    license = lib.licenses.gpl3;
    mainProgram = "cusf_predictor_wrapper";
    maintainers = with lib.maintainers; [ scd31 ];
  };
}

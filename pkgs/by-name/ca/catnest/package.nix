{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "catnest";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "eweOS";
    repo = "catnest";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/t1clnxBNU5lfTjtUbt5eOl5KPeAfG8Hq6jBVMqkkWY=";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildPhase = ''
    runHook preBuild

    $CC catnest.c -o catnest -std=gnu99

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 catnest -t $out/bin
    installManPage catnest.1

    runHook postInstall
  '';

  meta = {
    description = "Small, single-file and POSIX-compatible substituion for systemd-sysusers";
    homepage = "https://github.com/eweOS/catnest";
    license = lib.licenses.mit;
    mainProgram = "catnest";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.unix;
  };
})

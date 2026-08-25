{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "catnest";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "eweOS";
    repo = "catnest";
    rev = "v${finalAttrs.version}";
    hash = "sha256-rMIZZtsBX7Tyeg/HMj9fOU6d/VCdTHHiBeHGPtYFNu8=";
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
    description = "Small, single-file and POSIX-compatible substitution for systemd-sysusers";
    homepage = "https://github.com/eweOS/catnest";
    license = lib.licenses.mit;
    mainProgram = "catnest";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.unix;
  };
})

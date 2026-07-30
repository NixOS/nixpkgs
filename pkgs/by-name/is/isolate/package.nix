{
  lib,
  stdenv,
  fetchFromGitHub,
  asciidoc,
  libcap,
  pkg-config,
  systemdLibs,
  installShellFiles,
  nixosTests,
  libseccomp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "isolate";
  version = "2.5";

  src = fetchFromGitHub {
    owner = "ioi";
    repo = "isolate";
    rev = "v${finalAttrs.version}";
    hash = "sha256-a6FQxyClE9cXB0wHV0Z4kjYY6S1+mUE4ReroOifNjKg=";
  };

  nativeBuildInputs = [
    asciidoc
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    libcap.dev
    systemdLibs.dev
    libseccomp
  ];

  patches = [
    ./take-config-file-from-env.patch
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 ./isolate $out/bin/isolate
    install -Dm755 ./isolate-cg-keeper $out/bin/isolate-cg-keeper
    install -Dm755 ./isolate-check-environment $out/bin/isolate-check-environment
    installManPage isolate.1

    runHook postInstall
  '';

  passthru.tests = {
    isolate = nixosTests.isolate;
  };

  meta = {
    description = "Sandbox for securely executing untrusted programs";
    mainProgram = "isolate";
    homepage = "https://github.com/ioi/isolate";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ virchau13 ];
  };
})

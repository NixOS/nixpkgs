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
}:

stdenv.mkDerivation rec {
  pname = "isolate";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "ioi";
    repo = "isolate";
    rev = "v${version}";
    hash = "sha256-AacKIRS/Ah1KoE+bz+lK2GPbS3F3ifBGXvvCFWMd7hs=";
  };

  nativeBuildInputs = [
    asciidoc
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    libcap.dev
    systemdLibs.dev
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
}

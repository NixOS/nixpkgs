{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libcap,
  nix-update-script,
  nixosTests,
  stdenv,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "fingerd";
  version = "0.2.2-unstable-2025-11-20";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "PennockTech";
    repo = "fingerd";
    rev = "e013afe1594aa166aa00fcc38530aa5ab93030c8";
    hash = "sha256-kBEdpiLv0cDNx0QKioPXCVck3n2r9GzY9cVRWb1fTa0=";
  };

  vendorHash = "sha256-14dLQw6E2QfPH1cYRgGR6ymvbFTsizk3Zsx5ZBpcN6s=";

  subPackages = [ "." ];

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libcap
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.fingerVersion=${finalAttrs.version}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-version";

  # On Linux, does not run as root (avoids golang/go#1435 privilege drop issues);
  # uses setcap CAP_NET_BIND_SERVICE for port 79 when needed. Run unprivileged.
  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    setcap 'cap_net_bind_service=+ep' $out/bin/fingerd
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.basic = nixosTests.fingerd;
  };

  meta = {
    description = "Finger protocol server written in Go with security designed in from the beginning";
    longDescription = ''
      A finger protocol server, written in a safe programming language, with security
      designed in from the beginning and guidance on sandboxing. No operating-system
      information is revealed, only information explicitly chosen for disclosure.
    '';
    homepage = "https://github.com/PennockTech/fingerd";
    changelog = "https://github.com/PennockTech/fingerd/commits/main/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
    mainProgram = "fingerd";
    platforms = lib.platforms.unix;
  };
})

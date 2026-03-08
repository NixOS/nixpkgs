{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "iroh-ssh";
  version = "0.2.9";

  src = fetchFromGitHub {
    owner = "rustonbsd";
    repo = "iroh-ssh";
    tag = finalAttrs.version;
    hash = "sha256-0G2RZbxyxi96FpVPEamfcTrOgPxpFYHmyYg1kQfo7TQ=";
  };

  cargoHash = "sha256-2/hc1K6zUyQlWorZh34HP9PCdV4YD1ob9l1DFiW7c1Y=";

  nativeBuildInputs = [
    installShellFiles
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/iroh-ssh";
  versionCheckProgramArg = "version";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "SSH to any machine without IP";
    homepage = "https://github.com/rustonbsd/iroh-ssh";
    maintainers = with lib.maintainers; [
      luke
      rvdp
    ];
    license = lib.licenses.mit;
    mainProgram = "iroh-ssh";
  };
})

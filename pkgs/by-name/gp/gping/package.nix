{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch,
  installShellFiles,
  iputils,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gping";
  version = "1.20.4";

  src = fetchFromGitHub {
    owner = "orf";
    repo = "gping";
    tag = "gping-v${finalAttrs.version}";
    hash = "sha256-m26GtfRhgib13g+3/cXLwIdMKr3CofaMKFFCFKa8OI4=";
  };

  cargoHash = "sha256-CFJ7X0hJG6Whd9vMHo5Au93LueXiAHHEo9dPOKSmD+k=";

  patches = [
    (fetchpatch {
      name = "fix-ipv6-addrs-by-using-ping-dash-6.patch";
      # https://github.com/orf/gping/pull/546
      url = "https://github.com/orf/gping/commit/7ef8e1ddec847681c5ef3d4a010a0ad3a7aebab0.patch";
      hash = "sha256-b3Nv+mobPUcgREaNvn7cXra24PgEUe60yE/kOPTQEos=";
    })
  ];

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = lib.optionals stdenv.hostPlatform.isLinux [ iputils ];

  postInstall = ''
    installManPage gping.1
  '';

  # Requires internet access
  checkFlags = [
    "--skip=test::tests::test_integration_any"
    "--skip=test::tests::test_integration_ip6"
    "--skip=test::tests::test_integration_ipv4"
  ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Ping, but with a graph";
    homepage = "https://github.com/orf/gping";
    changelog = "https://github.com/orf/gping/releases/tag/gping-v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cafkafk ];
    mainProgram = "gping";
  };
})

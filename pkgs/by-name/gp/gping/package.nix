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
  version = "1.20.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "orf";
    repo = "gping";
    tag = "gping-v${finalAttrs.version}";
    hash = "sha256-5R47STjc8aQZ90SmsXXs86rLlE8YqWOzFRsFeSVkJKo=";
  };

  cargoHash = "sha256-P8v7RNZoycRpYRjjnT5rwBML9tuMvdGQU40uif5xj1c=";

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

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "gping-v(.*)"
    ];
  };

  meta = {
    description = "Ping, but with a graph";
    homepage = "https://github.com/orf/gping";
    changelog = "https://github.com/orf/gping/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      cafkafk
      kybe236
    ];
    mainProgram = "gping";
  };
})

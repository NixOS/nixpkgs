{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libpcap,
  nix-update-script,
  testers,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "netwatch";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "matthart1983";
    repo = "netwatch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jh6utHPkhVPAQQV7nnUBrvbHk5Jb88xH7eLW3QL+Vts=";
  };

  cargoHash = "sha256-pwqCgJSObVbO4z4A9jkFkslqQxlGk4GYzl8sGWxWU+0=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libpcap
  ];
  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    description = "Real-time network diagnostics in your terminal. One command, zero config, instant visibility";
    homepage = "https://github.com/matthart1983/netwatch";
    changelog = "https://github.com/matthart1983/netwatch/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ frantathefranta ];
    mainProgram = "netwatch";
  };
})

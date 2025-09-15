{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  libpcap,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustnet";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "domcyrus";
    repo = "rustnet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-x+B9YvxVOGqwdGSCDfnp2uCgDugSEMCGk4sCckhrWr8=";
  };

  cargoHash = "sha256-4H8nS968mzsxKhxxPJtBBkiS8U80Qqh2A+EmW5IHxec=";

  updateScript = nix-update-script { };

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  buildInputs = lib.optionals stdenv.isLinux [ libpcap ];

  meta = {
    description = "Cross-platform network monitoring terminal UI tool built with Rust";
    homepage = "https://github.com/domcyrus/rustnet";
    changelog = "https://github.com/domcyrus/rustnet/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ x123 ];
    mainProgram = "rustnet";
  };
})

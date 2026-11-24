{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  protobuf,
  rust-jemalloc-sys,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sozu";
  version = "2.3.6";

  src = fetchFromGitHub {
    owner = "sozu-proxy";
    repo = "sozu";
    tag = finalAttrs.version;
    hash = "sha256-1fUO5II+tg4cmZ0gj6rRNOvkOq/hobav3FlZm3OuIiE=";
  };

  cargoHash = "sha256-XHL1T/+WQJKIbkYckV6qLPDq/RwP7ffXhFeO5M6WiPo=";

  nativeBuildInputs = [ protobuf ];

  buildInputs = [ rust-jemalloc-sys ];

  doCheck = false;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open Source HTTP Reverse Proxy built in Rust for Immutable Infrastructures";
    homepage = "https://www.sozu.io";
    changelog = "https://github.com/sozu-proxy/sozu/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ kamadorueda ];
    mainProgram = "sozu";
    # error[E0432]: unresolved import `std::arch::x86_64`
    broken = !stdenv.hostPlatform.isx86_64;
  };
})

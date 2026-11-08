{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  zstd,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "darklua";
  version = "0.19.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "seaofvoices";
    repo = "darklua";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PEYQRUjd7Kil4y12shnw4CbIy75SiJdnzl26s7LTM+8=";
  };

  cargoHash = "sha256-ocjGev1T6Y6XxYZpO/tLH0U/Ge5uNGPa0xn2cvbF27A=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ zstd ];

  # error: linker `aarch64-linux-gnu-gcc` not found
  postPatch = ''
    rm .cargo/config.toml
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Command line tool that transforms Lua code";
    mainProgram = "darklua";
    homepage = "https://darklua.com";
    changelog = "https://github.com/seaofvoices/darklua/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomodachi94 ];
  };
})

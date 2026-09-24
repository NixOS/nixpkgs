{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "darklua";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "seaofvoices";
    repo = "darklua";
    rev = "v${finalAttrs.version}";
    hash = "sha256-PEYQRUjd7Kil4y12shnw4CbIy75SiJdnzl26s7LTM+8=";
  };

  cargoHash = "sha256-ocjGev1T6Y6XxYZpO/tLH0U/Ge5uNGPa0xn2cvbF27A=";

  # error: linker `aarch64-linux-gnu-gcc` not found
  postPatch = ''
    rm .cargo/config.toml
  '';

  meta = {
    description = "Command line tool that transforms Lua code";
    mainProgram = "darklua";
    homepage = "https://darklua.com";
    changelog = "https://github.com/seaofvoices/darklua/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomodachi94 ];
  };
})

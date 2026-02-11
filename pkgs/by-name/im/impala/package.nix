{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "impala";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "pythops";
    repo = "impala";
    rev = "v${finalAttrs.version}";
    hash = "sha256-zSoH0zY24m4XxWWBNUmMQozAtTiSDn4GD/HghXk4qI8=";
  };

  cargoHash = "sha256-wOoFQW5GIPNs+aA6JsU/g7/myJz45E9/0gNwKa3jSwI=";

  # fix for compilation of musl builds on aarch64
  # see https://github.com/NixOS/nixpkgs/issues/145726
  postPatch = ''
    rm .cargo/config.toml
  '';

  meta = {
    description = "TUI for managing wifi";
    homepage = "https://github.com/pythops/impala";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      nydragon
      saadndm
    ];
    mainProgram = "impala";
  };
})

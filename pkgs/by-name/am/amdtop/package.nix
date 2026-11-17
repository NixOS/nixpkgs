{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  libdrm,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "amdtop";
  version = "0.2.6";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "lhl";
    repo = "amdtop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-B7/J7jZrJosNot6hnTJ568DxqG+ZRurBPoMDrO4diBk=";
  };

  cargoHash = "sha256-JXnZ9tYXZywcemN5fQRP8efyhnV+8WVxguk2JEugpj0=";

  buildInputs = [
    libdrm
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Nvitop-style TUI frontend for amdgpu_top (AMDGPU + Strix Halo XDNA NPU";
    homepage = "https://github.com/lhl/amdtop";
    changelog = "https://github.com/lhl/amdtop/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pborzenkov ];
    mainProgram = "amdtop";
  };
})

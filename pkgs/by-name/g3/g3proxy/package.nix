{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  c-ares,
  python3,
  lua5_4,
  capnproto,
  openssl,
  rust-bindgen,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "g3proxy";
  version = "1.11.9";

  src = fetchFromGitHub {
    owner = "bytedance";
    repo = "g3";
    tag = "g3proxy-v${finalAttrs.version}";
    hash = "sha256-N6Fvdc+Vj7S9CgBby9unKBVBoM9pPlmfyJPxY3KdSXg=";
  };

  cargoHash = "sha256-bLzkA50XiIUrGyKZ3upo2psjFnjUNups0aIEou+J5IA=";

  cargoBuildFlags = [
    "-p"
    "g3proxy"
  ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  nativeBuildInputs = [
    pkg-config
    python3
    capnproto
    rust-bindgen
  ];

  buildInputs = [
    c-ares
    lua5_4
    openssl
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^g3proxy-v([0-9.]+)$"
    ];
  };

  meta = {
    description = "Enterprise-oriented Generic Proxy Solutions";
    homepage = "https://github.com/bytedance/g3";
    changelog = "https://github.com/bytedance/g3/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ raitobezarius ];
    mainProgram = "g3proxy";
  };
})

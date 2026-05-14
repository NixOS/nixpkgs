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
  version = "1.12.3";

  src = fetchFromGitHub {
    owner = "bytedance";
    repo = "g3";
    tag = "g3proxy-v${finalAttrs.version}";
    hash = "sha256-oVjHJPLNWV2bSJcm7La1z0M93kooYBZ+lSayYQ4aUxg=";
  };

  cargoHash = "sha256-zHnvrSI3NLyL7eP5PjB0xvLC7SjG/4UifR3OlqwwVIg=";

  cargoBuildFlags = [
    "-p"
    "g3proxy"
    "-p"
    "g3proxy-ctl"
    "-p"
    "g3proxy-lua"
    "-p"
    "g3proxy-ftp"
    "-p"
    "g3mkcert"
    "-p"
    "g3fcgen"
    "-p"
    "g3iploc"
    "-p"
    "g3statsd"
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

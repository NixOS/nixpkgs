{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  rustPlatform,
  dbus,
  xorg,
  pkg-config,
  writableTmpDirAsHomeHook,
  nix-update-script,
  llvmPackages,
}:

let
  gpt-4o-tokenizer = fetchurl {
    url = "https://huggingface.co/Xenova/gpt-4o/resolve/31376962e96831b948abe05d420160d0793a65a4/tokenizer.json";
    hash = "sha256-Q6OtRhimqTj4wmFBVOoQwxrVOmLVaDrgsOYTNXXO8H4=";
    meta.license = lib.licenses.unfree;
  };
  claude-tokenizer = fetchurl {
    url = "https://huggingface.co/Xenova/claude-tokenizer/resolve/cae688821ea05490de49a6d3faa36468a4672fad/tokenizer.json";
    hash = "sha256-wkFzffJLTn98mvT9zuKaDKkD3LKIqLdTvDRqMJKRF2c=";
    meta.license = lib.licenses.unfree;
  };
in
rustPlatform.buildRustPackage rec {
  pname = "goose-cli";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "block";
    repo = "goose";
    tag = "v${version}";
    hash = "sha256-9iTMT8n1bnHIYLAOknK3ts73CWkP9ztHeMAwi/btzjk=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  postPatch = ''
    # no Cargo.lock in src
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ dbus ] ++ lib.optionals stdenv.hostPlatform.isLinux [ xorg.libxcb ];

  env.LIBCLANG_PATH = "${lib.getLib llvmPackages.libclang}/lib";

  preBuild = ''
    mkdir -p tokenizer_files/Xenova--gpt-4o tokenizer_files/Xenova--claude-tokenizer
    ln -s ${gpt-4o-tokenizer} tokenizer_files/Xenova--gpt-4o/tokenizer.json
    ln -s ${claude-tokenizer} tokenizer_files/Xenova--claude-tokenizer/tokenizer.json
  '';

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  __darwinAllowLocalNetworking = true;

  checkFlags =
    [
      # need dbus-daemon
      "--skip=config::base::tests::test_multiple_secrets"
      "--skip=config::base::tests::test_secret_management"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # Lazy instance has previously been poisoned
      "--skip=jetbrains::tests::test_capabilities"
      "--skip=jetbrains::tests::test_router_creation"
    ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--generate-lockfile" ]; };

  meta = {
    description = "Open-source, extensible AI agent that goes beyond code suggestions - install, execute, edit, and test with any LLM";
    homepage = "https://github.com/block/goose";
    mainProgram = "goose";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nayeko ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}

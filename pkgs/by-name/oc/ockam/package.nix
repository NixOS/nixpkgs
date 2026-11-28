{
  lib,
  fetchFromGitHub,
  fetchurl,
  rustPlatform,
  git,
  nix-update-script,
  pkg-config,
  oniguruma,
  openssl,
  sqlite,
  versionCheckHook,
  zstd,
  dbus,
}:

let
  # The ockam_ebpf crate downloads its prebuilt eBPF program at build time;
  # building it from source needs bpf-linker and a nightly toolchain.
  ockam-ebpf = fetchurl {
    url = "https://github.com/build-trust/ockam-ebpf/releases/download/v0.6.0/ockam_ebpf";
    hash = "sha256-IPl40/qn8DsZmSu81aag6ANFv/aTdOc11h5oL1ElxG0=";
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ockam";
  version = "0.157.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "build-trust";
    repo = "ockam";
    rev = "ockam_v${finalAttrs.version}";
    hash = "sha256-o895VPlUGmLUsIeOnShjCetKoS/4x0nbEKxipEbuBu4=";
  };

  cargoHash = "sha256-hHbMMi4nuTORUPEKEo3OiQg7y12+cXHzUAkh3ApYx5s=";

  # sqlx < 0.8.4 opens in-memory databases without SQLITE_OPEN_URI, so with the
  # system SQLite every pooled connection gets its own empty database.
  # https://github.com/launchbadge/sqlx/pull/3289
  postPatch = ''
    substituteInPlace $cargoDepsCopy/*/sqlx-sqlite-*/src/connection/establish.rs \
      --replace-fail 'flags |= SQLITE_OPEN_MEMORY;' 'flags |= SQLITE_OPEN_MEMORY | libsqlite3_sys::SQLITE_OPEN_URI;'

    substituteInPlace $cargoDepsCopy/*/ockam_ebpf-*/build.rs \
      --replace-fail 'if output_versioned.exists() {' 'if true { std::fs::copy("${ockam-ebpf}", &output_versioned).unwrap();'

    # size-of implements its trait for function pointers with calling conventions
    # that rustc now rejects on targets that don't support them; keep the
    # portable ones.
    substituteInPlace $cargoDepsCopy/*/size-of-*/src/core_impls.rs \
      --replace-fail '"aapcs",' "" \
      --replace-fail '"cdecl",' "" \
      --replace-fail '"win64",' "" \
      --replace-fail '"sysv64",' "" \
      --replace-fail '"stdcall",' "" \
      --replace-fail '"fastcall",' ""

    # Newer rustc runs out of query depth on ockam_command's nested async fns
    sed -i '1i #![recursion_limit = "256"]' implementations/rust/ockam/ockam_command/src/lib.rs
  '';

  nativeBuildInputs = [
    git
    pkg-config
  ];
  buildInputs = [
    oniguruma
    openssl
    sqlite
    zstd
    dbus
  ];

  passthru.updateScript = nix-update-script { };

  # too many tests fail for now
  doCheck = false;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  cargoBuildFlags = [
    "--package=ockam_command"
    "--bin=ockam"
  ];

  meta = {
    description = "Orchestrate end-to-end encryption, cryptographic identities, mutual authentication, and authorization policies between distributed applications – at massive scale";
    homepage = "https://github.com/build-trust/ockam";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
    maintainers = with lib.maintainers; [ happysalada ];
    mainProgram = "ockam";
  };
})

{
  lib,
  buildPackages,
  rustPlatform,
  rust-cbindgen,
  expect,
  stdenv,
}:

let
  src = buildPackages.fetchgit {
    url = "https://gitlab.redox-os.org/redox-os/relibc/";
    rev = "7ed934a01d2ac8ab603b6dc24e918d8197192068";
    hash = "sha256-1+1c0RrjtQqaY1Fy/5MgM5tYvd4Sbj+vxJvdhDzi95Q=";
    fetchSubmodules = true;
  };
  target = stdenv.hostPlatform.rust.rustcTargetSpec;
  lockFile = ./Cargo.lock;
in
rustPlatform.buildRustPackage {
  pname = "relibc";
  version = "0.2.5";

  src = src;

  RUSTC_BOOTSTRAP = 1;

  doCheck = false;
  patchPhase = ''
    patchShebangs --build renamesyms.sh stripcore.sh
  '';

  buildPhase = ''
    make CC=gcc AR=ar LD=ld NM=nm CARGO_COMMON_FLAGS="" all
  '';

  installPhase = ''
    mkdir -p $out
    DESTDIR=$out make CC=gcc AR=ar LD=ld NM=nm install
  '';

  nativeBuildInputs = [
    rust-cbindgen
    expect
  ];

  TARGET = target;

  cargoLock = {
    lockFile = lockFile;
    outputHashes = {
      "cc-1.1.22" = "sha256-qHnTYnx6aUDDZSuoVX521HPc6oC5mF4qJDCJEDZe9u0=";
      "object-0.36.7" = "sha256-vKH7JPy84mt5W2vyH3nK2u64TroKSw+OiXXg2bTAHGU=";
      "redox_event-0.4.0" = "sha256-6DPFABc5bG6bppDzmLQ3q0gHQcmnooIY27H661h+Ees=";
      "redox_syscall-0.5.13" = "sha256-QV/ODe0/5fknQ+S2VnbO51A+sd+akKyrU3zwxayWZjQ=";
    };
  };

  # error: Usage of `RUSTC_WORKSPACE_WRAPPER` requires `-Z unstable-options`
  auditable = false;

  meta = with lib; {
    homepage = "https://gitlab.redox-os.org/redox-os/relibc";
    description = "C Library in Rust for Redox and Linux";
    license = licenses.mit;
    maintainers = [ maintainers.anderscs ];
    platforms = platforms.redox ++ [ "x86_64-linux" ];
  };
}

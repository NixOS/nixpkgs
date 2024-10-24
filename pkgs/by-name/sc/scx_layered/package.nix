{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  llvmPackages,
  elfutils,
  zlib,
  ...
}:

rustPlatform.buildRustPackage rec {
  pname = "scx_layered";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "sched-ext";
    repo = "scx";
    rev = "v${version}";
    hash = "sha256-nb2bzEanPPWTUhMmGw/8/bwOkdgNmwoZX2lMFq5Av5Q=";
  };

  # The build for scx is quite complicated. The root Cargo file will build all
  # of the Rust schedulers and ignore all of the C schedulers. To keep things
  # simple, build one scheduler per derivation.
  cargoRoot = "scheds/rust/scx_layered";
  cargoLock.lockFile = ./Cargo.lock;
  postPatch = ''
    rm Cargo.toml Cargo.lock
    ln -fs ${./Cargo.lock} scheds/rust/scx_layered/Cargo.lock
  '';
  preBuild = ''
    cd scheds/rust/scx_layered
  '';

  nativeBuildInputs = [
    pkg-config
    llvmPackages.clang
  ];
  buildInputs = [
    elfutils
    zlib
  ];

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp target/${stdenv.targetPlatform.config}/release/scx_layered $out/bin/

    runHook postInstall
  '';

  # fails on BPF targets which are built in build.rs
  hardeningDisable = [
    "zerocallusedregs"
  ];

  meta = with lib; {
    description = "scx_layered sched_ext userspace scheduler";
    homepage = "https://github.com/sched-ext/scx";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jakehillion ];
  };
}

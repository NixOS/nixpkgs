{
  lib,
  rustPlatform,
  rust-cbindgen,
  expect,
  stdenv,
  fetchFromGitLab,
  nix-update-script,
  fetchpatch,
}:
rustPlatform.buildRustPackage {
  pname = "relibc";
  version = "0.2.5-unstable-2026-04-17";

  src = fetchFromGitLab {
    owner = "redox-os";
    repo = "relibc";
    rev = "24a481364fd3cd2a2a186204ef929ef37e0e5137";
    hash = "sha256-Qt6kk/7WT18T31839FkiSy8fm2PtSoYvIC2RL+QjQns=";
    fetchSubmodules = true;
    domain = "gitlab.redox-os.org";
  };

  cargoHash = "sha256-0F+RW9/zz6b2HUaOADBaJq0hVyJEe+djtBN4LwoKUYA=";

  env = {
    RUSTC_BOOTSTRAP = 1;
    TARGET = stdenv.hostPlatform.rust.rustcTargetSpec;
  };

  # error: Usage of `RUSTC_WORKSPACE_WRAPPER` requires `-Z unstable-options`
  auditable = false;

  doCheck = false;
  postPatch = ''
    patchShebangs --build renamesyms.sh stripcore.sh
  '';

  patches = [
    # Fixes the issues with stable rust 1.94
    # https://gitlab.redox-os.org/redox-os/relibc/-/merge_requests/1204
    (fetchpatch {
      url = "https://gitlab.redox-os.org/eveeifyeve/relibc/-/commit/fa171808ee01995f6b33cfb48b8dc37bc2439caf.patch";
      hash = "sha256-QVSoMt2ZugoDyyK33FqX2nEHQH1ZqsqLMgNHfaUZajw=";
    })
  ];

  # relibc expects target-triple-prefixed GNU binutils (e.g. `x86_64-linux-gnu-ar`), which Nixpkgs doesn't expose natively; this makes it so unprefixed tools are used instead.
  # See https://gitlab.redox-os.org/redox-os/relibc/-/blob/master/README.md#im-building-for-my-own-platform-which-i-run-and-am-getting-x86_64-linux-gnu-ar-command-not-found-or-similar for more info.
  makeFlags = [
    "CC=gcc"
    "AR=ar"
    "LD=ld"
    "NM=nm"
  ];

  buildPhase = ''
    runHook preBuild

    make $makeFlags CARGO_COMMON_FLAGS="" all

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    DESTDIR=$out make $makeFlagsinstall

    runHook postInstall
  '';

  nativeBuildInputs = [
    rust-cbindgen
    expect
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    homepage = "https://gitlab.redox-os.org/redox-os/relibc";
    description = "C Library in Rust for Redox and Linux";
    license = lib.licenses.mit;
    platforms = lib.platforms.redox ++ lib.platforms.linux;
    teams = [ lib.teams.redox ];
  };
}

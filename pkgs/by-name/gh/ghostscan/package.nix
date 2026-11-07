{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  buildPackages,
  libbpf,
  elfutils,
  zlib,
  linuxPackages,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ghostscan";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "h2337";
    repo = "ghostscan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KDgWL8UYgD3RVie5UPPY3pwfH1vnjXE8aVELw6bEVbs=";
  };

  cargoHash = "sha256-pfvJs0yKTcea/Tue4hdudQaVjuUfhbLp/DWwuAVyQ6g=";

  strictDeps = true;
  __structuredAttrs = true;

  # Link against the libbpf, libelf, and zlib from Nixpkgs instead of building
  # vendored copies.  libbpf-rs enables the default features of libbpf-sys,
  # which would vendor libbpf again through feature unification, so its
  # dependency is patched as well.
  postPatch = ''
    substituteInPlace Cargo.toml \
      --replace-fail 'libbpf-sys = { version = "1.6.1", features = ["vendored"] }' \
        'libbpf-sys = { version = "1.6.1", default-features = false }'
    substituteInPlace "$cargoDepsCopy"/*/libbpf-rs-*/Cargo.toml \
      --replace-fail '[dependencies.libbpf-sys]' $'[dependencies.libbpf-sys]\ndefault-features = false'
  '';

  buildInputs = [
    libbpf
    elfutils
    zlib
  ];

  env = {
    # Unwrapped clang is used for the BPF target, so pass libbpf headers explicitly
    BPF_CLANG = lib.getExe' buildPackages.llvmPackages.clang-unwrapped "clang";
    C_INCLUDE_PATH = "${lib.getDev libbpf}/include";
    # vmlinux.h is derived from the BTF of the Nixpkgs kernel, since the build
    # sandbox has no access to /sys/kernel/btf/vmlinux.
    BPF_VMLINUX_H = "${linuxPackages.ebpf-headers}/vmlinux.h";
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Unmask hidden rootkits, stealthy eBPF tricks and ghost processes";
    longDescription = ''
      ghostscan is the grab-it-run-it-read-it toolkit for responders
      who need a fast gut check on a Linux host.  Drop the binary on a
      box, run it once, and ghostscan walks the kernel, procfs, bpffs,
      systemd, cron, sockets, and more to surface the things an
      attacker would rather you never notice.
    '';
    homepage = "https://github.com/h2337/ghostscan";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "ghostscan";
    platforms = lib.platforms.linux;
  };
})

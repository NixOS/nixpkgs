{
  lib,
  stdenv,
  python3,
  fetchPypi,
  llvmPackages,
  libbpf,
  libnotify,
  makeWrapper,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "picosnitch";
  version = "2.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1d13fc48280f6a355bcb155d193f93817c1225475ee9670846a56cbd39e2014d";
  };

  build-system = with python3.pkgs; [ hatchling ];

  nativeBuildInputs = [
    # Unwrapped clang/llvm: cc-wrapper injects flags (hardening,
    # --gcc-toolchain, fortify) that `clang -target bpf` rejects under -Werror.
    llvmPackages.clang-unwrapped
    llvmPackages.llvm
    makeWrapper
  ];

  buildInputs = [ libbpf ];

  # The sdist ships vendored vmlinux_{x86,arm64}.h, so the BPF compile is
  # fully offline. Pre-build the .bpf.o here with an explicit libbpf include
  # path; the hatch build hook sees the existing .o (newer than the .c) and
  # reuses it instead of invoking clang itself.
  preBuild = ''
    bpfTargetArch=${if stdenv.hostPlatform.isAarch64 then "arm64" else "x86"}
    cp src/picosnitch/bpf/vmlinux_$bpfTargetArch.h src/picosnitch/bpf/vmlinux.h
    clang -g -O2 -target bpf -D__TARGET_ARCH_$bpfTargetArch \
      -Wall -Werror -Wno-missing-declarations \
      -I${lib.getDev libbpf}/include \
      -Isrc/picosnitch/bpf \
      -c src/picosnitch/bpf/picosnitch.bpf.c \
      -o src/picosnitch/bpf/picosnitch.bpf.o
    llvm-strip -g src/picosnitch/bpf/picosnitch.bpf.o || true
  '';

  # The build hook keys the wheel platform tag and BPF target arch off this var.
  env.PICOSNITCH_BPF_TARGET_ARCH =
    if stdenv.hostPlatform.isAarch64 then
      "aarch64"
    else if stdenv.hostPlatform.isx86_64 then
      "x86_64"
    else
      throw "picosnitch: unsupported platform ${stdenv.hostPlatform.system}";

  pythonImportsCheck = [ "picosnitch" ];

  # picosnitch loads libbpf via ctypes and shells out to `notify-send`.
  postFixup = ''
    wrapProgram $out/bin/picosnitch \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libbpf ]} \
      --prefix PATH : ${lib.makeBinPath [ libnotify ]}
  '';

  meta = {
    description = "Monitor network traffic per executable using BPF";
    mainProgram = "picosnitch";
    homepage = "https://github.com/elesiuta/picosnitch";
    changelog = "https://github.com/elesiuta/picosnitch/releases";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.elesiuta ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}

{
  bison,
  cmake,
  cmocka,
  doxygen,
  fetchFromGitHub,
  flex,
  gitMinimal,
  lcov,
  lib,
  libbpf,
  libelf,
  libnl,
  nix-update-script,
  pkg-config,
  sphinx,
  stdenv,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bpfilter";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "bpfilter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8oF4YuVlxWwl0JgAAe3JRz0Sy5xe77Ayhvour9K3zeY=";
  };

  nativeBuildInputs = [
    bison
    cmake
    cmocka
    doxygen
    flex
    lcov
    pkg-config
    sphinx

    # bpfilter's cmake files requires this, even if we specify the version
    # we're using without needing to detect the version during the build.
    gitMinimal
  ];

  buildInputs = [
    libbpf
    libelf
    libnl
    zlib
  ];

  cmakeFlags = [
    "-DDEFAULT_PROJECT_VERSION=${finalAttrs.version}"
    "-DNO_TESTS=1" # tries to clone nftables
    "-DNO_CHECKS=1"
    "-DNO_BENCHMARKS=1"
  ];

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  preFixup = ''
    substituteInPlace $out/lib/systemd/system/bpfilter.service --replace-fail /usr/sbin/bpfilter $out/bin/bpfilter

    # workaround for https://github.com/NixOS/nixpkgs/issues/144170
    substituteInPlace $lib/lib/pkgconfig/bpfilter.pc --replace-fail \''${prefix}/ ""
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "BPF-based packet filtering framework";
    homepage = "https://bpfilter.io";
    changelog = "https://github.com/facebook/bpfilter/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.jmbaur ];
    mainProgram = "bpfilter";
    platforms = lib.platforms.linux;
  };
})

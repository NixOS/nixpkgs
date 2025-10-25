{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
  python3,
  cunit,
  dpdk,
  fuse3,
  libaio,
  libbsd,
  libuuid,
  nasm,
  autoconf,
  automake,
  libtool,
  numactl,
  openssl,
  pkg-config,
  zlib,
  zstd,
  libpcap,
  libnl,
  elfutils,
  fetchurl,
  jansson,
  ensureNewerSourcesForZipFilesHook,
  runtimeShell,
}:

let

  # downgrade dpdk because spdk refuses newer versions at runtime
  # url: https://github.com/spdk/spdk/blob/3e3577a090ed9a084b5909aadcc8bc5fe93c0017/lib/env_dpdk/pci_dpdk.c#L77
  dpdk' = dpdk.overrideAttrs (oldAttrs: rec {
    version = "25.03";
    src = fetchurl {
      url = "https://fast.dpdk.org/rel/dpdk-${version}.tar.xz";
      sha256 = "sha256-akCnMTKChuvXloWxj/pZkua3cME4Q9Zf0NEVfPzP9j0=";
    };
  });

in
stdenv.mkDerivation rec {
  pname = "spdk";

  version = "25.05";

  src = fetchFromGitHub {
    owner = "spdk";
    repo = "spdk";
    tag = "v${version}";
    hash = "sha256-Js78FLkLN4GpJlgO+h4jIiEdThciBugbLTB6elFi2TI=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    python3
    python3.pkgs.pip
    python3.pkgs.hatchling
    python3.pkgs.wheel
    python3.pkgs.wrapPython
    pkg-config
    ensureNewerSourcesForZipFilesHook
  ];

  buildInputs = [
    cunit
    dpdk'
    fuse3
    jansson
    libaio
    libbsd
    elfutils
    libuuid
    libpcap
    libnl
    numactl
    openssl
    ncurses
    zlib
    zstd
    nasm
    autoconf
    automake
    libtool
  ];

  propagatedBuildInputs = [
    python3.pkgs.configshell-fb
  ];

  patches = [
    # Otherwise the DPDK version is not detected correctly
    # Upstream PR: https://review.spdk.io/c/spdk/spdk/+/26964
    ./patches/configure.patch
  ];

  postPatch = ''
    patchShebangs .
    # Override pip install command to use hatchling directly without downloading dependencies
    substituteInPlace python/Makefile \
      --replace-fail "setup_cmd = pip install --prefix=\$(CONFIG_PREFIX)" \
                     "setup_cmd = python3 -m pip install --no-deps --no-build-isolation --prefix=\$(CONFIG_PREFIX)"

    # The nasm detection in the vendored version of isa-l_crypto is broken
    # Upstream fix: https://github.com/intel/isa-l_crypto/commit/0850c01cc03e45f77d5883372dd6be983ba163ce
    substituteInPlace isa-l-crypto/configure.ac \
      --replace-fail "AC_LANG_CONFTEST([AC_LANG_SOURCE([[vpcompressb zmm0, k1, zmm1;]])])" \
                     "AC_LANG_CONFTEST([AC_LANG_SOURCE([[vpcompressb zmm0 {k1}, zmm1;]])])"
  '';

  enableParallelBuilding = true;

  # Required for the vendored isa-l version to find nasm
  preConfigure = ''
    export AS=nasm
  '';

  configureFlags = [
    "--with-dpdk=${dpdk'}"
    "--with-crypto"
  ]
  ++ lib.optional (!stdenv.hostPlatform.isStatic) "--with-shared";

  # spdk does shenanigans with patchelf, so we need to stop them from messing with rpath
  preInstall = ''
    patchelf() { true; }
    export -f patchelf
  '';

  postInstall = ''
    unset patchelf

    # The rpaths of the vendored libisal.so.2 and libisal_crypto.so.2 are not correctly set
    for item in $out/lib/*.so* $out/bin/*; do
      if file "$item" 2>/dev/null | grep -q 'ELF'; then
        patchelf --replace-needed libisal.so.2 $out/lib/libisal.so.2 "$item"
        patchelf --replace-needed libisal_crypto.so.2 $out/lib/libisal_crypto.so.2 "$item"
      fi
    done

    # SPDK scripts assume that they can read the includes also relative to the scripts.
    # Therefore we are not copying them into $out/share.
    mkdir $out/scripts
    cp  ./scripts/common.sh ./scripts/setup.sh $out/scripts
    cat > $out/bin/spdk-setup << EOF
    #!${runtimeShell}
    exec $out/scripts/setup.sh "\$@"
    EOF
    chmod +x  $out/bin/spdk-setup
  '';

  postCheck = ''
    python3 -m spdk
  '';

  postFixup = ''
    wrapPythonPrograms
    ${lib.optionalString (!stdenv.hostPlatform.isStatic) ''
      # .pc files are not working properly with static linking and might just confuse other build systems
      rm $out/lib/*.a
    ''}
  '';

  env.NIX_CFLAGS_COMPILE = "-mssse3"; # Necessary to compile.

  passthru.dpdk = dpdk';

  meta = with lib; {
    description = "Set of libraries for fast user-mode storage";
    homepage = "https://spdk.io/";
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ orivej ];
  };
}

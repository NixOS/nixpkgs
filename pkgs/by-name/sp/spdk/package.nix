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

stdenv.mkDerivation rec {
  pname = "spdk";

  version = "26.01";

  src = fetchFromGitHub {
    owner = "spdk";
    repo = "spdk";
    tag = "v${version}";
    hash = "sha256-E52VozjnoGnIC7viXrsualaaKXiUU9Fx8zGylTjBzX0=";
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
    dpdk
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

  postPatch = ''
    patchShebangs .
    # Override uv pip install command to use hatchling directly without downloading dependencies
    substituteInPlace python/Makefile \
      --replace-fail "uv pip install --prefix=\$(CONFIG_PREFIX)" \
                     "python3 -m pip install --no-deps --no-build-isolation --prefix=\$(CONFIG_PREFIX)"
  '';

  enableParallelBuilding = true;

  # Required for the vendored isa-l version to find nasm
  preConfigure = ''
    export AS=nasm
  '';

  configureFlags = [
    "--with-dpdk=${dpdk}"
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

    # Clean up rpaths to remove /build references to the vendored isa-l and isa-l_crypto libs
    for f in $(find $out/lib $out/bin -executable -type f 2>/dev/null); do
      if patchelf --print-rpath "$f" 2>/dev/null | grep /build; then
        echo "Stripping rpath of $f"
        newrp=$(patchelf --print-rpath "$f" | sed -r "s|/build[^:]*:||g")
        patchelf --set-rpath "$newrp" "$f"
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

  meta = {
    description = "Set of libraries for fast user-mode storage";
    homepage = "https://spdk.io/";
    license = lib.licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ ths-on ];
  };
}

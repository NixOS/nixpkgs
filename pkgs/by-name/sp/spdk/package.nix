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
  ];

  propagatedBuildInputs = [
    python3.pkgs.configshell-fb
  ];

  postPatch = ''
    patchShebangs .
    # Override pip install command to use hatchling directly without downloading dependencies
    substituteInPlace python/Makefile \
      --replace-fail "setup_cmd = pip install --prefix=\$(CONFIG_PREFIX)" \
                     "setup_cmd = python3 -m pip install --no-deps --no-build-isolation --prefix=\$(CONFIG_PREFIX)"
  '';

  enableParallelBuilding = true;

  configureFlags = [
    "--with-dpdk=${dpdk'}"
  ]
  ++ lib.optional (!stdenv.hostPlatform.isStatic) "--with-shared";

  # spdk does shenanigans with patchelf, so we need to stop them from messing with rpath
  preInstall = ''
    patchelf() { true; }
    export -f patchelf
  '';

  postInstall = ''
    unset patchelf

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

{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  meson,
  ninja,
  makeWrapper,
  libbsd,
  numactl,
  libbpf,
  zlib,
  elfutils,
  intel-ipsec-mb,
  jansson,
  openssl,
  libpcap,
  rdma-core,
  doxygen,
  python3,
  pciutils,
  withExamples ? [ ],
  shared ? false,
  machine ? (
    if stdenv.hostPlatform.isx86_64 then
      "nehalem"
    else if stdenv.hostPlatform.isAarch64 then
      "generic"
    else
      null
  ),
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dpdk";
  version = "26.03";

  src = fetchurl {
    url = "https://fast.dpdk.org/rel/dpdk-${finalAttrs.version}.tar.xz";
    hash = "sha256-hJiSArvg+67rYvj9xj9pGICsC2bNDcZMFnhDxZ2ynSw=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    makeWrapper
    doxygen
    meson
    ninja
    pkg-config
    python3
    python3.pkgs.sphinx
    python3.pkgs.pyelftools
  ];
  buildInputs = [
    jansson
    libbpf
    elfutils
    libpcap
    numactl
    openssl.dev
    zlib
    python3
  ]
  ++ lib.optionals stdenv.hostPlatform.isx86_64 [
    intel-ipsec-mb
  ];

  propagatedBuildInputs = [
    # Propagated to support current DPDK users in nixpkgs which statically link
    # with the framework (e.g. odp-dpdk).
    rdma-core
    # Requested by pkg-config.
    libbsd
  ];

  postPatch = ''
    patchShebangs config/arm buildtools
  '';

  mesonFlags = [
    (lib.mesonBool "tests" false)
    (lib.mesonBool "enable_docs" true)
    (lib.mesonEnable "developer_mode" false)
    (lib.mesonOption "default_library" (if shared then "shared" else "static"))
  ]
  ++ lib.optionals (machine != null) [ (lib.mesonOption "machine" machine) ]
  ++ lib.optionals (withExamples != [ ]) [
    (lib.mesonOption "examples" (lib.concatStringsSep "," withExamples))
  ];

  postInstall = ''
    # Remove Sphinx cache files. Not only are they not useful, but they also
    # contain store paths causing spurious dependencies.
    rm -rf $out/share/doc/dpdk/html/.doctrees

    wrapProgram $out/bin/dpdk-devbind.py \
      --prefix PATH : "${lib.makeBinPath [ pciutils ]}"
  ''
  + lib.optionalString (withExamples != [ ]) ''
    mkdir -p $examples/bin
    find examples -type f -executable -exec install {} $examples/bin \;
  '';

  outputs = [
    "out"
    "doc"
  ]
  ++ lib.optional (withExamples != [ ]) "examples";

  meta = {
    description = "Set of libraries and drivers for fast packet processing";
    homepage = "http://dpdk.org/";
    license = with lib.licenses; [
      lgpl21
      gpl2Only
      bsd2
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      mic92
      zhaofengli
    ];
  };
})

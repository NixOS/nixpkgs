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
  fetchpatch,
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

stdenv.mkDerivation rec {
  pname = "dpdk";
  version = "25.11";

  src = fetchurl {
    url = "https://fast.dpdk.org/rel/dpdk-${version}.tar.xz";
    sha256 = "sha256-UukNKlMe897QKDvZGryUmAaY8fZHH6CWWKAhfPZglSY=";
  };

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
    intel-ipsec-mb
    libpcap
    numactl
    openssl.dev
    zlib
    python3
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
    "-Dtests=false"
    "-Denable_docs=true"
    "-Ddeveloper_mode=disabled"
  ]
  ++ [ (if shared then "-Ddefault_library=shared" else "-Ddefault_library=static") ]
  ++ lib.optional (machine != null) "-Dmachine=${machine}"
  ++ lib.optional (withExamples != [ ]) "-Dexamples=${builtins.concatStringsSep "," withExamples}";

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

  meta = with lib; {
    description = "Set of libraries and drivers for fast packet processing";
    homepage = "http://dpdk.org/";
    license = with licenses; [
      lgpl21
      gpl2Only
      bsd2
    ];
    platforms = platforms.linux;
    maintainers = with maintainers; [
      mic92
      zhaofengli
    ];
  };
}

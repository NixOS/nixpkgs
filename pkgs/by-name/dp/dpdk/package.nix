{
  stdenv,
  lib,
  fetchurl,
  fetchpatch2,
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
  version = "26.07";

  src = fetchurl {
    url = "https://fast.dpdk.org/rel/dpdk-${finalAttrs.version}.tar.xz";
    hash = "sha256-cUGotbrZ19llSDrA11MXrAwh3O4dE9NzaTxlX54/q+Y=";
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

  patches = [
    (fetchpatch2 {
      name = "CVE-2026-86848.patch";
      url = "https://github.com/DPDK/dpdk/commit/a9be1f10fe03dfee32956efd997192d940fec10a.patch?full_index=1";
      hash = "sha256-dWWnqZarLYZRsC9XsR4DkxAAsZRAYF6ftLBMBJTxSkI=";
    })
    (fetchpatch2 {
      name = "CVE-2026-86561.patch";
      url = "https://github.com/DPDK/dpdk/commit/54bce6b5a533c0c9b6180280cf16648f11e80704.patch?full_index=1";
      hash = "sha256-lgYdATONHDxk7DAiD9UNvTYQgW3puAroNUAN21cIaag=";
    })
    (fetchpatch2 {
      name = "CVE-2026-86562.patch";
      url = "https://github.com/DPDK/dpdk/commit/496a28b507d56b592477452074e1c7fa73dbcf6b.patch?full_index=1";
      hash = "sha256-F4W5aqx/dLhtwRAKCo55keQJm77tc4AeY9Be79c/Jv0=";
    })
    (fetchpatch2 {
      name = "CVE-2026-86563.patch";
      url = "https://github.com/DPDK/dpdk/commit/baf01488fcee9733ee0881a7f27221bfb2e7ca63.patch?full_index=1";
      hash = "sha256-ct8CgLQSVLin+QAfy6baqmtom/MAHP1RXh3VyyvEMJ8=";
    })
    (fetchpatch2 {
      name = "CVE-2026-86567.patch";
      url = "https://github.com/DPDK/dpdk/commit/8593123488ac9454d0233983d2cc0ba187763bd0.patch?full_index=1";
      hash = "sha256-9QTswrWxoW+U+kTg3u68L8oiuOjJ+evT2nH1GQdwKYw=";
    })
    (fetchpatch2 {
      name = "CVE-2026-86566.patch";
      url = "https://github.com/DPDK/dpdk/commit/c0ad2f990717fac9bd58f2609fa2f6f2977603ea.patch?full_index=1";
      hash = "sha256-eWFWbDqHzLnpplricNARBs5rBp/DQDqBAKlYKeMjItU=";
    })
    (fetchpatch2 {
      name = "CVE-2026-86849.patch";
      url = "https://github.com/DPDK/dpdk/commit/4310d1316307ad6132e874d618cb39a34b2a004e.patch?full_index=1";
      hash = "sha256-5gOIUaS3yAlXKC7129DQU5VhWRK3CF9FmSKlP3BaSeQ=";
    })
    (fetchpatch2 {
      name = "CVE-2026-86845.patch";
      url = "https://github.com/DPDK/dpdk/commit/714b873be37405ba7986bebd97071850fd00f753.patch?full_index=1";
      hash = "sha256-dPPootwWzve5qX3lIpNOHBuwZ+kMxoE5Zb5/Wsbf+1g=";
    })
    (fetchpatch2 {
      name = "CVE-2026-86847.patch";
      url = "https://github.com/DPDK/dpdk/commit/6c183fef85af85f9f05fb6158a757421a5405ab7.patch?full_index=1";
      hash = "sha256-S5/yVLIIF3coOXxyXobpGoYkKWLKuyV6zad7oteopBk=";
    })
    (fetchpatch2 {
      name = "CVE-2026-86856.patch";
      url = "https://github.com/DPDK/dpdk/commit/342238357f1684449ce6e399dc6cfd82c45d9658.patch?full_index=1";
      hash = "sha256-PVK9h41Qmr42CuDntszbF3NVPP39qOfzrIMJ7X+VXJE=";
    })
    (fetchpatch2 {
      name = "CVE-2026-86564.patch";
      url = "https://github.com/DPDK/dpdk/commit/08481c06e8b10bf3d25460bc0ec1d5c4e86aacd1.patch?full_index=1";
      hash = "sha256-p9iKNdMWW/Go01XwE1PWI9muZuUHgBHhNz+ZncW1OVI=";
    })
    (fetchpatch2 {
      name = "CVE-2026-86565.patch";
      url = "https://github.com/DPDK/dpdk/commit/7458ddf82bb42b141fee88c25508ad85b5198ba8.patch?full_index=1";
      hash = "sha256-KSwiiDJwWRuJ5BFvbuivWrvJYtrTBBN/Jt15L5lLXW4=";
    })
    (fetchpatch2 {
      name = "CVE-2026-93683.patch";
      url = "https://github.com/DPDK/dpdk/commit/b053a220786fca7915fae98cb41942804456bbe5.patch?full_index=1";
      hash = "sha256-z7GBY3VlbhpnS2MvQn4PCAvf0OcGcwFx41yULmxyc9A=";
    })
    (fetchpatch2 {
      name = "CVE-2026-100236.patch";
      url = "https://github.com/DPDK/dpdk/commit/2a58f6ea787ad47e97790fc77ec0fe8e17d615c0.patch?full_index=1";
      hash = "sha256-MBWhuFikoewv4Mt36w4ty2/tzrNbUg1jCWbc48DgH+Y=";
    })
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
      stepbrobd
      zhaofengli
    ];
  };
})

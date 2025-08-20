{ stdenv, lib
, fetchurl
, pkg-config, meson, ninja, makeWrapper
, libbsd, numactl, libbpf, zlib, elfutils, jansson, openssl, libpcap, rdma-core
, doxygen, python3, pciutils
, fetchpatch
, withExamples ? []
, shared ? false
, machine ? (
    if stdenv.hostPlatform.isx86_64 then "nehalem"
    else if stdenv.hostPlatform.isAarch64 then "generic"
    else null
  )
}:

stdenv.mkDerivation rec {
  pname = "dpdk";
  version = "24.07";

  src = fetchurl {
    url = "https://fast.dpdk.org/rel/dpdk-${version}.tar.xz";
    sha256 = "sha256-mUT35fJo56ybQZPizVTvbZj24dfd3JZ8d65PZhbW+70=";
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

  patches = [
    (fetchpatch {
      name = "CVE-2024-11614.patch";
      url = "https://git.dpdk.org/dpdk-stable/patch/?id=fdf13ea6fede07538fbe5e2a46fa6d4b2368fa81";
      hash = "sha256-lD2mhPm5r1tWZb4IpzHa2SeK1DyQ3rwjzArRTpAgZAY=";
    })
  ];

  postPatch = ''
    patchShebangs config/arm buildtools
  '';

  mesonFlags = [
    "-Dtests=false"
    "-Denable_docs=true"
    "-Ddeveloper_mode=disabled"
  ]
  ++ [(if shared then "-Ddefault_library=shared" else "-Ddefault_library=static")]
  ++ lib.optional (machine != null) "-Dmachine=${machine}"
  ++ lib.optional (withExamples != []) "-Dexamples=${builtins.concatStringsSep "," withExamples}";

  postInstall = ''
    # Remove Sphinx cache files. Not only are they not useful, but they also
    # contain store paths causing spurious dependencies.
    rm -rf $out/share/doc/dpdk/html/.doctrees

    wrapProgram $out/bin/dpdk-devbind.py \
      --prefix PATH : "${lib.makeBinPath [ pciutils ]}"
  '' + lib.optionalString (withExamples != []) ''
    mkdir -p $examples/bin
    find examples -type f -executable -exec install {} $examples/bin \;
  '';

  outputs =
    [ "out" "doc" ]
    ++ lib.optional (withExamples != []) "examples";

  meta = with lib; {
    description = "Set of libraries and drivers for fast packet processing";
    homepage = "http://dpdk.org/";
    license = with licenses; [ lgpl21 gpl2Only bsd2 ];
    platforms =  platforms.linux;
    maintainers = with maintainers; [ magenbluten orivej mic92 zhaofengli ];
  };
}

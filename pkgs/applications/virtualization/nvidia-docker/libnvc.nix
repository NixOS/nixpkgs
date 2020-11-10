{ stdenv
, lib
, fetchFromGitHub
, pkgconfig
, libelf
, libcap
, libseccomp
, rpcsvc-proto
, libtirpc
}:
let
  modp-ver = "396.51";
  nvidia-modprobe = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nvidia-modprobe";
    rev = modp-ver;
    sha256 = "1fw2qwc84k64agw6fx2v0mjf88aggph9c6qhs4cv7l3gmflv8qbk";
  };
in
stdenv.mkDerivation rec {
  pname = "libnvidia-container";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "libnvidia-container";
    rev = "v${version}";
    sha256 = "1pnpc9knwh8d1zqb28zc3spkjc00w0z10vd3jna8ksvpl35jl7w3";
  };

  patches = [
    # locations of nvidia-driver libraries are not resolved via ldconfig which
    # doesn't get used on NixOS. Additional support binaries like nvidia-smi
    # are not resolved via the environment PATH but via the derivation output
    # path.
    ./libnvc-ldconfig-and-path-fixes.patch

    # the libnvidia-container Makefile wants to build and install static
    # libtirpc libraries; this patch prevents that from happening
    ./avoid-static-libtirpc-build.patch
  ];

  makeFlags = [
    "WITH_LIBELF=yes"
    "prefix=$(out)"
    # we can't use the WITH_TIRPC=yes flag that exists in the Makefile for the
    # same reason we patch out the static library use of libtirpc so we set the
    # define in CFLAGS
    "CFLAGS=-DWITH_TIRPC"
  ];

  postPatch = ''
    sed -i \
      -e 's/^REVISION :=.*/REVISION = ${src.rev}/' \
      -e 's/^COMPILER :=.*/COMPILER = $(CC)/' \
      mk/common.mk

    mkdir -p deps/src/nvidia-modprobe-${modp-ver}
    cp -r ${nvidia-modprobe}/* deps/src/nvidia-modprobe-${modp-ver}
    chmod -R u+w deps/src
    touch deps/src/nvidia-modprobe-${modp-ver}/.download_stamp
  '';

  NIX_CFLAGS_COMPILE = [ "-I${libtirpc.dev}/include/tirpc" ];
  NIX_LDFLAGS = [ "-L${libtirpc.dev}/lib" "-ltirpc" ];

  nativeBuildInputs = [ pkgconfig rpcsvc-proto ];

  buildInputs = [ libelf libcap libseccomp libtirpc ];

  meta = with lib; {
    homepage = "https://github.com/NVIDIA/libnvidia-container";
    description = "NVIDIA container runtime library";
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}

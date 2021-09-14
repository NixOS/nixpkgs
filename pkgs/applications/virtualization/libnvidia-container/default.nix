{ stdenv
, lib
, fetchFromGitHub
, pkg-config
, libelf
, libcap
, libseccomp
, rpcsvc-proto
, libtirpc
, makeWrapper
}:
let
  modp-ver = "450.57";
  nvidia-modprobe = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nvidia-modprobe";
    rev = modp-ver;
    sha256 = "0r4f6lpbbqqs9932xd2mr7bxn6a3xdalcwq332fc1amrrkgzfyv7";
  };
in
stdenv.mkDerivation rec {
  pname = "libnvidia-container";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-b9yQ1mEo1EkjXMguV0t98OvFEQO4h76EVu154MsB2II=";
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
      -e 's/^REVISION ?=.*/REVISION = ${src.rev}/' \
      -e 's/^COMPILER :=.*/COMPILER = $(CC)/' \
      mk/common.mk

    mkdir -p deps/src/nvidia-modprobe-${modp-ver}
    cp -r ${nvidia-modprobe}/* deps/src/nvidia-modprobe-${modp-ver}
    chmod -R u+w deps/src
    pushd deps/src
    patch -p0 < ${./modprobe.patch}
    touch nvidia-modprobe-${modp-ver}/.download_stamp
    popd
  '';

  postInstall = ''
    wrapProgram $out/bin/nvidia-container-cli \
      --prefix LD_LIBRARY_PATH : /run/opengl-driver/lib:/run/opengl-driver-32/lib
  '';

  NIX_CFLAGS_COMPILE = [ "-I${libtirpc.dev}/include/tirpc" ];
  NIX_LDFLAGS = [ "-L${libtirpc.dev}/lib" "-ltirpc" ];

  nativeBuildInputs = [ pkg-config rpcsvc-proto makeWrapper ];

  buildInputs = [ libelf libcap libseccomp libtirpc ];

  meta = with lib; {
    homepage = "https://github.com/NVIDIA/libnvidia-container";
    description = "NVIDIA container runtime library";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cpcloud ];
  };
}

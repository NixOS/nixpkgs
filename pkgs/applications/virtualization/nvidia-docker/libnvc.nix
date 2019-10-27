{ stdenv, lib, fetchFromGitHub, libelf, libcap, libseccomp }:

with lib; let

  modp-ver = "396.51";

  nvidia-modprobe = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nvidia-modprobe";
    rev = modp-ver;
    sha256 = "1fw2qwc84k64agw6fx2v0mjf88aggph9c6qhs4cv7l3gmflv8qbk";
  };

in stdenv.mkDerivation rec {
  pname = "libnvidia-container";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "libnvidia-container";
    rev = "v${version}";
    sha256 = "1ws6mfsbgxhzlb5w1r8qqg2arvxkr21n59i4cqsyz3h5jsqsflbw";
  };

  # locations of nvidia-driver libraries are not resolved via ldconfig which
  # doesn't get used on NixOS. Additional support binaries like nvidia-smi are
  # not resolved via the environment PATH but via the derivation output path.
  patches = [ ./libnvc-ldconfig-and-path-fixes.patch ];

  makeFlags = [
    "WITH_LIBELF=yes"
    "prefix=$(out)"
  ];

  postPatch = ''
    sed -i 's/^REVISION :=.*/REVISION = ${src.rev}/' mk/common.mk
    sed -i 's/^COMPILER :=.*/COMPILER = $(CC)/' mk/common.mk

    mkdir -p deps/src/nvidia-modprobe-${modp-ver}
    cp -r ${nvidia-modprobe}/* deps/src/nvidia-modprobe-${modp-ver}
    chmod -R u+w deps/src
    touch deps/src/nvidia-modprobe-${modp-ver}/.download_stamp
  '';

  buildInputs = [ libelf libcap libseccomp ];

  meta = {
    homepage = https://github.com/NVIDIA/libnvidia-container;
    description = "NVIDIA container runtime library";
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}

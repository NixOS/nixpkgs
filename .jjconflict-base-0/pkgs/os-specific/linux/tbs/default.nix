{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
  kmod,
  patchutils,
  perlPackages,
}:
let

  media = fetchFromGitHub rec {
    name = repo;
    owner = "tbsdtv";
    repo = "linux_media";
    rev = "36ce48448be5dd42669a5199f61e85da1a68cf60";
    hash = "sha256-fbb1ITcWymLoybA7VkfdpJmuRHKCP1s0CqLn0Rl2E2I=";
  };

  build = fetchFromGitHub rec {
    name = repo;
    owner = "tbsdtv";
    repo = "media_build";
    rev = "0f49c76b80838ded04bd64c56af9e1f9b8ac1965";
    hash = "sha256-S5g7OTBJjzClLfy6C0PJwUtukrqoCiIjyU26Yy26hDo=";
  };

in
stdenv.mkDerivation {
  pname = "tbs";
  version = "20241026-${kernel.version}";

  srcs = [
    media
    build
  ];
  sourceRoot = build.name;

  # https://github.com/tbsdtv/linux_media/wiki
  preConfigure = ''
    make dir DIR=../${media.name}
    make allyesconfig
    sed --regexp-extended --in-place v4l/.config \
      -e 's/(^CONFIG.*_RC.*=)./\1n/g' \
      -e 's/(^CONFIG.*_IR.*=)./\1n/g' \
      -e 's/(^CONFIG_VIDEO_VIA_CAMERA=)./\1n/g'
  '';

  postPatch = ''
    patchShebangs .

    sed -i v4l/Makefile \
      -i v4l/scripts/make_makefile.pl \
      -e 's,/sbin/depmod,${kmod}/bin/depmod,g' \
      -e 's,/sbin/lsmod,${kmod}/bin/lsmod,g'

    sed -i v4l/Makefile \
      -e 's,^OUTDIR ?= /lib/modules,OUTDIR ?= ${kernel.dev}/lib/modules,' \
      -e 's,^SRCDIR ?= /lib/modules,SRCDIR ?= ${kernel.dev}/lib/modules,'
  '';

  buildFlags = [ "VER=${kernel.modDirVersion}" ];
  installFlags = [ "DESTDIR=$(out)" ];

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = [
    patchutils
    kmod
    perlPackages.ProcProcessTable
  ] ++ kernel.moduleBuildDependencies;

  postInstall = ''
    find $out/lib/modules/${kernel.modDirVersion} -name "*.ko" -exec xz {} \;
  '';

  meta = {
    homepage = "https://www.tbsdtv.com/";
    description = "Linux driver for TBSDTV cards";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ ck3d ];
    priority = -1;
    broken = kernel.kernelOlder "4.14" || kernel.kernelAtLeast "6.12";
  };
}

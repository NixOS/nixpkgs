{ stdenv, lib, autoreconfHook, acl, go, file, git, wget, gnupg1, trousers, squashfsTools,
  cpio, fetchurl, fetchFromGitHub, iptables, systemd, makeWrapper, glibc }:

let
  # Always get the information from 
  # https://github.com/coreos/rkt/blob/v${VERSION}/stage1/usr_from_coreos/coreos-common.mk
  coreosImageRelease = "1068.0.0";
  coreosImageSystemdVersion = "229";

  # TODO: track https://github.com/coreos/rkt/issues/1758 to allow "host" flavor.
  stage1Flavours = [ "coreos" "fly" ];

in stdenv.mkDerivation rec {
  version = "1.9.1";
  name = "rkt-${version}";
  BUILDDIR="build-${name}";

  src = fetchFromGitHub {
      rev = "v${version}";
      owner = "coreos";
      repo = "rkt";
      sha256 = "094pqxcn91g1s3f0ly3z2lb11s4q3dn99h8cr7lqalkd0gj9l4xg";
  };

  stage1BaseImage = fetchurl {
    url = "http://alpha.release.core-os.net/amd64-usr/${coreosImageRelease}/coreos_production_pxe_image.cpio.gz";
    sha256 = "06jawmjkhrrw9hsk98w5j6pxci17d46mvzbj52pslakacw60pbpp";
  };

  buildInputs = [
    glibc.out glibc.static
    autoreconfHook go file git wget gnupg1 trousers squashfsTools cpio acl systemd
    makeWrapper
  ];

  preConfigure = ''
    ./autogen.sh
    configureFlagsArray=(
      --with-stage1-flavors=${builtins.concatStringsSep "," stage1Flavours}
      ${if lib.findFirst (p: p == "coreos") null stage1Flavours != null then "
      --with-coreos-local-pxe-image-path=${stage1BaseImage}
      --with-coreos-local-pxe-image-systemd-version=v${coreosImageSystemdVersion}
      " else "" }
    );
  '';

  preBuild = ''
    export BUILDDIR
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -Rv $BUILDDIR/bin/* $out/bin
    wrapProgram $out/bin/rkt \
      --prefix LD_LIBRARY_PATH : ${systemd}/lib \
      --prefix PATH : ${iptables}/bin
  '';

  meta = with lib; {
    description = "A fast, composable, and secure App Container runtime for Linux";
    homepage = https://github.com/coreos/rkt;
    license = licenses.asl20;
    maintainers = with maintainers; [ ragge steveej ];
    platforms = [ "x86_64-linux" ];
  };
}

{ stdenv, lib, autoconf, automake, go, file, git, wget, gnupg1, squashfsTools, cpio
, fetchurl, fetchFromGitHub }:

let
  coreosImageRelease = "794.1.0";
  coreosImageSystemdVersion = "222";
  stage1Flavour = "coreos";

in stdenv.mkDerivation rec {
  version = "0.10.0";
  name = "rkt-${version}";
  BUILDDIR="build-${name}";

  src = fetchFromGitHub {
      rev = "v${version}";
      owner = "coreos";
      repo = "rkt";
      sha256 = "1d9n00wkzib4v5mfl46f2mqc8zfpv33kqixifmv8p4azqv78cbxn";
  };

  stage1BaseImage = fetchurl {
    url = "http://alpha.release.core-os.net/amd64-usr/${coreosImageRelease}/coreos_production_pxe_image.cpio.gz";
    sha256 = "05nzl3av6cawr8v203a8c95c443g6h1nfy2n4jmgvn0j4iyy44ym";
  };

  buildInputs = [ autoconf automake go file git wget gnupg1 squashfsTools cpio ];

  preConfigure = ''
    ./autogen.sh
    configureFlagsArray=(
      --with-stage1=${stage1Flavour}
      --with-stage1-image-path=$out/stage1-${stage1Flavour}.aci
      --with-coreos-local-pxe-image-path=${stage1BaseImage}
      --with-coreos-local-pxe-image-systemd-version=v${coreosImageSystemdVersion}
    );
  '';

  preBuild = ''
    export BUILDDIR
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -Rv $BUILDDIR/bin/* $out/bin
  '';

  meta = with lib; {
    description = "A fast, composable, and secure App Container runtime for Linux";
    homepage = https://github.com/coreos/rkt;
    license = licenses.asl20;
    maintainers = with maintainers; [ ragge steveej ];
    platforms = [ "x86_64-linux" ];
  };
}

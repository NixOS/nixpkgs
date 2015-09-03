{ stdenv, lib, autoconf, automake, go, file, git, wget, gnupg1, squashfsTools, cpio
, fetchurl, fetchFromGitHub }:

let
  coreosImageRelease = "738.1.0";

in stdenv.mkDerivation rec {
  version = "0.8.0";
  name = "rkt-${version}";

  src = fetchFromGitHub {
      rev = "v${version}";
      owner = "coreos";
      repo = "rkt";
      sha256 = "1abv9psd5w0m8p2kvrwyjnrclzajmrpbwfwmkgpnkydhmsimhnn0";
  };

  stage1image = fetchurl {
    url = "http://alpha.release.core-os.net/amd64-usr/${coreosImageRelease}/coreos_production_pxe_image.cpio.gz";
    sha256 = "1rnb9rwms5g7f142d9yh169a5k2hxiximpgk4y4kqmc1294lqnl0";
  };

  buildInputs = [ autoconf automake go file git wget gnupg1 squashfsTools cpio ];

  preConfigure = ''
    ./autogen.sh
  '';

  preBuild = ''
    # hack to avoid downloading image during build, this has been
    # improved in rkt master
    mkdir -p build-rkt-0.8.0/tmp/usr_from_coreos
    cp -v ${stage1image} build-rkt-0.8.0/tmp/usr_from_coreos/pxe.img
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -Rv build-rkt-${version}/bin/* $out/bin
  '';

  meta = with lib; {
    description = "A fast, composable, and secure App Container runtime for Linux";
    homepage = http://rkt.io;
    license = licenses.asl20;
    maintainers = with maintainers; [ ragge ];
    platforms = [ "x86_64-linux" ];
  };
}

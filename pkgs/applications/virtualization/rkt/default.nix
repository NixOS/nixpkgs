{ stdenv, lib, autoreconfHook, acl, go, file, git, wget, gnupg1, trousers, squashfsTools,
  cpio, fetchurl, fetchFromGitHub, iptables, systemd, makeWrapper, glibc }:

let
  # Always get the information from
  # https://github.com/coreos/rkt/blob/v${VERSION}/stage1/usr_from_coreos/coreos-common.mk
  coreosImageRelease = "1478.0.0";
  coreosImageSystemdVersion = "233";

  # TODO: track https://github.com/coreos/rkt/issues/1758 to allow "host" flavor.
  stage1Flavours = [ "coreos" "fly" ];
  stage1Dir = "lib/rkt/stage1-images";

in stdenv.mkDerivation rec {
  version = "1.29.0";
  name = "rkt-${version}";
  BUILDDIR="build-${name}";

  src = fetchFromGitHub {
    owner = "coreos";
    repo = "rkt";
    rev = "v${version}";
    sha256 = "0wnhii15pr4z190iladfcl4jzj9sgyl1bn5v63a3yy6nkmz9cfda";
  };

  stage1BaseImage = fetchurl {
    url = "http://alpha.release.core-os.net/amd64-usr/${coreosImageRelease}/coreos_production_pxe_image.cpio.gz";
    sha256 = "0s4qdkkfp0iirfnm5ds3b3hxq0249kvpygyhflma8z90ivkzk5wq";
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
      --with-stage1-default-location=$out/${stage1Dir}/stage1-${builtins.elemAt stage1Flavours 0}.aci
    );
  '';

  preBuild = ''
    export BUILDDIR
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -Rv $BUILDDIR/target/bin/rkt $out/bin

    mkdir -p $out/lib/rkt/stage1-images/
    cp -Rv $BUILDDIR/target/bin/stage1-*.aci $out/${stage1Dir}/

    wrapProgram $out/bin/rkt \
      --prefix LD_LIBRARY_PATH : "${systemd.lib}/lib:${acl.out}/lib" \
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

{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netkit-tftp";
  version = "0.17";

  src = fetchurl {
    urls = [
      "mirror://ubuntu/pool/universe/n/netkit-tftp/netkit-tftp_${finalAttrs.version}.orig.tar.gz"
      "ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/netkit-tftp-${finalAttrs.version}.tar.gz"
      "https://ftp.cc.uoc.gr/mirrors/linux/ubuntu/packages/pool/universe/n/netkit-tftp/netkit-tftp_${finalAttrs.version}.orig.tar.gz"
    ];
    hash = "sha256-OkPAAQ1OYfQSVj/YN2nUZn2LjoKQNSbSHLkgX+Va0U0=";
  };

  patches = [
    # fix compilation errors, warning and many style issues
    (fetchpatch {
      url = "https://sources.debian.org/data/main/n/netkit-tftp/0.17-23/debian/patches/debian_changes_0.17-18.patch";
      hash = "sha256-kprmSMoNF6E8GGRIPWDLWcqfPRxdUeheeLoFNqI3Uv0=";
    })
  ];

  preInstall = "
    mkdir -p $out/man/man{1,8} $out/sbin $out/bin
  ";

  meta = {
    description = "Netkit TFTP client and server";
    homepage = "ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/";
    license = lib.licenses.bsdOriginal;
    maintainers = [ ];
    platforms = with lib.platforms; linux;
  };
})

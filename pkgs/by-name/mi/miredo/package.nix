{
  lib,
  stdenv,
  fetchurl,
  nettools,
  iproute2,
  judy,
}:

stdenv.mkDerivation rec {
  version = "1.2.6";
  pname = "miredo";

  buildInputs = [ judy ];

  src = fetchurl {
    url = "https://www.remlab.net/files/miredo/miredo-${version}.tar.xz";
    sha256 = "0j9ilig570snbmj48230hf7ms8kvcwi2wblycqrmhh85lksd49ps";
  };

  postPatch = ''
    substituteInPlace misc/client-hook.bsd \
      --replace '/sbin/route' '${nettools}/bin/route' \
      --replace '/sbin/ifconfig' '${nettools}/bin/ifconfig'
    substituteInPlace misc/client-hook.iproute --replace '/sbin/ip' '${iproute2}/bin/ip'
  '';

  configureFlags = [ "--with-Judy" ];

  postInstall = ''
    rm -rf $out/lib/systemd $out/var $out/etc/miredo/miredo.conf
  '';

  meta = with lib; {
    description = "Teredo IPv6 Tunneling Daemon";
    homepage = "https://www.remlab.net/miredo/";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}

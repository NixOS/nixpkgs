{
  lib,
  stdenv,
  fetchurl,
  net-tools,
  iproute2,
  judy,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.2.6";
  pname = "miredo";

  buildInputs = [ judy ];

  src = fetchurl {
    url = "https://www.remlab.net/files/miredo/miredo-${finalAttrs.version}.tar.xz";
    sha256 = "0j9ilig570snbmj48230hf7ms8kvcwi2wblycqrmhh85lksd49ps";
  };

  postPatch = ''
    substituteInPlace misc/client-hook.bsd \
      --replace '/sbin/route' '${net-tools}/bin/route' \
      --replace '/sbin/ifconfig' '${net-tools}/bin/ifconfig'
    substituteInPlace misc/client-hook.iproute --replace '/sbin/ip' '${iproute2}/bin/ip'
  '';

  configureFlags = [ "--with-Judy" ];

  postInstall = ''
    rm -rf $out/lib/systemd $out/var $out/etc/miredo/miredo.conf
  '';

  meta = {
    description = "Teredo IPv6 Tunneling Daemon";
    homepage = "https://www.remlab.net/miredo/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})

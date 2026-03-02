{
  lib,
  stdenv,
  fetchFromCodeberg,
  ppp,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "rp-pppoe";
  version = "4.0";

  src = fetchFromCodeberg {
    owner = "dskoll";
    repo = "rp-pppoe";
    tag = finalAttrs.version;
    hash = "sha256-2y26FVxVn8sU9/E2yJeJmbhAeOB0Go7EUPMU9H58H6U=";
  };

  buildInputs = [ ppp ];

  preConfigure = ''
    cd src
    export PPPD=${ppp}/sbin/pppd
  '';

  configureFlags = [
    "--enable-plugin=${ppp}/include"
  ]
  ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [ "rpppoe_cv_pack_bitfields=rev" ];

  postConfigure = ''
    sed -i Makefile -e 's@DESTDIR)/etc/ppp@out)/etc/ppp@'
    sed -i Makefile -e 's@/etc/ppp/plugins@$(out)/lib@'
    sed -i Makefile -e 's@PPPOESERVER_PPPD_OPTIONS=@&$(out)@'
    sed -i Makefile -e '/# Directory created by rp-pppoe for kernel-mode plugin/d'
  '';

  makeFlags = [ "AR:=$(AR)" ];

  meta = {
    description = "Roaring Penguin Point-to-Point over Ethernet tool";
    platforms = lib.platforms.linux;
    homepage = "https://github.com/dfskoll/rp-pppoe";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ DictXiong ];
  };
})

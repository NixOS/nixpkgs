{
  lib,
  stdenv,
  fetchFromGitHub,
  ppp,
}:
let
in
stdenv.mkDerivation rec {
  pname = "rp-pppoe";
  version = "4.0";

  src = fetchFromGitHub {
    owner = "dfskoll";
    repo = "rp-pppoe";
    rev = version;
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

  meta = with lib; {
    description = "Roaring Penguin Point-to-Point over Ethernet tool";
    platforms = platforms.linux;
    homepage = "https://github.com/dfskoll/rp-pppoe";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ DictXiong ];
  };
}

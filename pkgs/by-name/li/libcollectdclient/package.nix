{ lib, collectd }:

collectd.overrideAttrs (prevAttrs: {
  pname = "libcollectdclient";

  buildInputs = [ ];

  configureFlags = (prevAttrs.configureFlags or [ ]) ++ [
    "--with-perl-bindings=no"
    "--disable-daemon"
    "--disable-all-plugins"
  ];

  postInstall = "rm -rf $out/{bin,etc,sbin,share}";

  meta = {
    description = "C Library for collectd, a daemon which collects system performance statistics periodically";
    homepage = "https://collectd.org";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ bjornfor ];
  };
})

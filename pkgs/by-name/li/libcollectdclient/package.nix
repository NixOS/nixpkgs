{ lib, collectd }:

collectd.overrideAttrs (oldAttrs: {
  pname = "libcollectdclient";
  inherit (collectd) version;
  buildInputs = [ ];

  configureFlags = (oldAttrs.configureFlags or [ ]) ++ [
    "--disable-daemon"
    "--disable-all-plugins"
  ];

  postInstall = "rm -rf $out/{bin,etc,sbin,share}";

  meta = {
    description = "C Library for collectd, a daemon which collects system performance statistics periodically";
    homepage = "http://collectd.org";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux; # TODO: collectd may be linux but the C client may be more portable?
    maintainers = with lib.maintainers; [
      sheenobu
      bjornfor
    ];
  };
})

{
  ceph,
  runCommand,
  ...
}:
let
  inherit (ceph) version;
  inherit (ceph.python) sitePackages;
in
runCommand "ceph-client-${version}"
  {
    meta = ceph.meta // {
      description = "Tools needed to mount Ceph's RADOS Block Devices/Cephfs";
      outputsToInstall = [ "out" ];
    };
  }
  ''
    mkdir -p $out/{bin,etc,${sitePackages},share/bash-completion/completions}
    cp -r ${ceph}/bin/{ceph,.ceph-wrapped,rados,rbd,rbdmap} $out/bin
    cp -r ${ceph}/bin/ceph-{authtool,conf,dencoder,rbdnamer,syn} $out/bin
    cp -r ${ceph}/bin/rbd-replay* $out/bin
    cp -r ${ceph}/sbin/mount.ceph $out/bin
    cp -r ${ceph}/sbin/mount.fuse.ceph $out/bin
    ln -s bin $out/sbin
    cp -r ${ceph}/${sitePackages}/* $out/${sitePackages}
    cp -r ${ceph}/etc/bash_completion.d $out/share/bash-completion/completions
    # wrapPythonPrograms modifies .ceph-wrapped, so lets just update its paths
    substituteInPlace $out/bin/ceph          --replace-fail ${ceph} $out
    substituteInPlace $out/bin/.ceph-wrapped --replace-fail ${ceph} $out
  ''

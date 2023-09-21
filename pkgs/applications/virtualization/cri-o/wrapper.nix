{ cri-o-unwrapped
, runCommand
, makeWrapper
, lib
, extraPackages ? []
, runc # Default container runtime
, conntrack-tools
, crun # Container runtime (default with cgroups v2 for podman/buildah)
, conmon # Container runtime monitor
, util-linux # nsenter
, iptables
}:

let
  binPath = lib.makeBinPath ([
    runc
    conntrack-tools
    crun
    conmon
    util-linux
    iptables
  ] ++ extraPackages);

in runCommand cri-o-unwrapped.name {
  name = "${cri-o-unwrapped.pname}-wrapper-${cri-o-unwrapped.version}";
  inherit (cri-o-unwrapped) pname version passthru;

  preferLocalBuild = true;

  meta = builtins.removeAttrs cri-o-unwrapped.meta [ "outputsToInstall" ];

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

} ''
  ln -s ${cri-o-unwrapped.man} $man

  mkdir -p $out/bin
  ln -s ${cri-o-unwrapped}/etc $out/etc
  ln -s ${cri-o-unwrapped}/share $out/share

  for p in ${cri-o-unwrapped}/bin/*; do
    makeWrapper $p $out/bin/''${p##*/} \
      --prefix PATH : ${binPath}
  done
''

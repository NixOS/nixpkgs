{ cri-o-unwrapped
, runCommand
, makeWrapper
, lib
, extraPackages ? []
, cri-o
, runc # Default container runtime
, crun # Container runtime (default with cgroups v2 for podman/buildah)
, conmon # Container runtime monitor
, util-linux # nsenter
, iptables
}:

let
  cri-o = cri-o-unwrapped;

  binPath = lib.makeBinPath ([
    runc
    crun
    conmon
    util-linux
    iptables
  ] ++ extraPackages);

in runCommand cri-o.name {
  name = "${cri-o.pname}-wrapper-${cri-o.version}";
  inherit (cri-o) pname version passthru;

  preferLocalBuild = true;

  meta = builtins.removeAttrs cri-o.meta [ "outputsToInstall" ];

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

} ''
  ln -s ${cri-o.man} $man

  mkdir -p $out/bin
  ln -s ${cri-o-unwrapped}/share $out/share

  for p in ${cri-o-unwrapped}/bin/*; do
    makeWrapper $p $out/bin/''${p##*/} \
      --prefix PATH : ${binPath}
  done
''

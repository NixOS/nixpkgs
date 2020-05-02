{ podman-unwrapped
, runCommand
, makeWrapper
, lib
, extraPackages ? []
, podman # Docker compat
, runc # Default container runtime
, crun # Container runtime (default with cgroups v2 for podman/buildah)
, conmon # Container runtime monitor
, slirp4netns # User-mode networking for unprivileged namespaces
, fuse-overlayfs # CoW for images, much faster than default vfs
, utillinux # nsenter
, cni-plugins # not added to path
, iptables
}:

let
  podman = podman-unwrapped;

  binPath = lib.makeBinPath ([
    runc
    crun
    conmon
    slirp4netns
    fuse-overlayfs
    utillinux
    iptables
  ] ++ extraPackages);

in runCommand podman.name {
  name = "${podman.pname}-wrapper-${podman.version}";
  inherit (podman) pname version passthru;

  meta = builtins.removeAttrs podman.meta [ "outputsToInstall" ];

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

} ''
  ln -s ${podman.man} $man

  mkdir -p $out/bin
  ln -s ${podman-unwrapped}/share $out/share
  makeWrapper ${podman-unwrapped}/bin/podman $out/bin/podman \
    --prefix PATH : ${binPath}
''

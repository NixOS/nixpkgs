{ podman-unwrapped
, runCommand
, makeWrapper
, lib
, extraPackages ? []
, podman # Docker compat
, runc # Default container runtime
, crun # Default container runtime (cgroups v2)
, conmon # Container runtime monitor
, slirp4netns # User-mode networking for unprivileged namespaces
, fuse-overlayfs # CoW for images, much faster than default vfs
, utillinux # nsenter
, cni-plugins
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
  inherit (podman) name pname version meta outputs;
  nativeBuildInputs = [
    makeWrapper
  ];

} ''
  # Symlink everything but $bin from podman-unwrapped
  ${
    lib.concatMapStringsSep "\n"
    (o: "ln -s ${podman.${o}} ${placeholder o}")
    (builtins.filter (o: o != "bin")
    podman.outputs)}

  mkdir -p $bin/bin
  ln -s ${podman-unwrapped}/share $bin/share
  makeWrapper ${podman-unwrapped}/bin/podman $bin/bin/podman \
    --prefix PATH : ${binPath}
''

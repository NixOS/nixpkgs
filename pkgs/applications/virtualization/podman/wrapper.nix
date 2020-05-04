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

  outputs = [
    "out"
    "man"
  ];

in runCommand podman.name {
  name = "${podman.pname}-wrapper-${podman.version}";
  inherit (podman) pname version;

  meta = builtins.removeAttrs podman.meta [ "outputsToInstall" ];

  inherit outputs;

  nativeBuildInputs = [
    makeWrapper
  ];

} ''
  # Symlink everything but $out from podman-unwrapped
  ${
    lib.concatMapStringsSep "\n"
    (o: "ln -s ${podman.${o}} ${placeholder o}")
    (builtins.filter (o: o != "out")
    outputs)}

  mkdir -p $out/bin
  ln -s ${podman-unwrapped}/share $out/share
  makeWrapper ${podman-unwrapped}/bin/podman $out/bin/podman \
    --prefix PATH : ${binPath}
''

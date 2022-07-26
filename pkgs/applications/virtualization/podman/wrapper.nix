{ podman-unwrapped
, runCommand
, makeWrapper
, symlinkJoin
, lib
, stdenv
, extraPackages ? []
, podman # Docker compat
, runc # Default container runtime
, crun # Container runtime (default with cgroups v2 for podman/buildah)
, conmon # Container runtime monitor
, slirp4netns # User-mode networking for unprivileged namespaces
, fuse-overlayfs # CoW for images, much faster than default vfs
, util-linux # nsenter
, cni-plugins # not added to path
, iptables
, iproute2
, catatonit
, gvproxy
}:

# do not add qemu to this wrapper, store paths get written to the podman vm config and break when GCed

# adding aardvark-dns/netavark to `helpersBin` requires changes to the modules and tests

let
  podman = podman-unwrapped;

  binPath = lib.makeBinPath ([
  ] ++ lib.optionals stdenv.isLinux [
    runc
    crun
    conmon
    slirp4netns
    fuse-overlayfs
    util-linux
    iptables
    iproute2
  ] ++ extraPackages);

  helpersBin = symlinkJoin {
    name = "${podman.pname}-helper-binary-wrapper-${podman.version}";

    # this only works for some binaries, others may need to be be added to `binPath` or in the modules
    paths = [
      gvproxy
    ] ++ lib.optionals stdenv.isLinux [
      catatonit # added here for the pause image and also set in `containersConf` for `init_path`
      podman.rootlessport
    ];
  };

in runCommand podman.name {
  name = "${podman.pname}-wrapper-${podman.version}";
  inherit (podman) pname version passthru;

  preferLocalBuild = true;

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
  ln -s ${podman-unwrapped}/etc $out/etc
  ln -s ${podman-unwrapped}/lib $out/lib
  ln -s ${podman-unwrapped}/share $out/share
  makeWrapper ${podman-unwrapped}/bin/podman $out/bin/podman \
    --set CONTAINERS_HELPER_BINARY_DIR ${helpersBin}/bin \
    --prefix PATH : ${lib.escapeShellArg binPath}
''

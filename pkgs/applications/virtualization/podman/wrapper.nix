{ podman-unwrapped
, runCommand
, makeWrapper
, symlinkJoin
, lib
, stdenv
, extraPackages ? []
, runc # Default container runtime
, crun # Container runtime (default with cgroups v2 for podman/buildah)
, conmon # Container runtime monitor
, slirp4netns # User-mode networking for unprivileged namespaces
, fuse-overlayfs # CoW for images, much faster than default vfs
, util-linux # nsenter
, iptables
, iproute2
, catatonit
, gvproxy
, aardvark-dns
, netavark
}:

# do not add qemu to this wrapper, store paths get written to the podman vm config and break when GCed

let
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
    name = "${podman-unwrapped.pname}-helper-binary-wrapper-${podman-unwrapped.version}";

    # this only works for some binaries, others may need to be be added to `binPath` or in the modules
    paths = [
      gvproxy
    ] ++ lib.optionals stdenv.isLinux [
      aardvark-dns
      catatonit # added here for the pause image and also set in `containersConf` for `init_path`
      netavark
      podman-unwrapped.rootlessport
    ];
  };

in runCommand podman-unwrapped.name {
  name = "${podman-unwrapped.pname}-wrapper-${podman-unwrapped.version}";
  inherit (podman-unwrapped) pname version passthru;

  preferLocalBuild = true;

  meta = builtins.removeAttrs podman-unwrapped.meta [ "outputsToInstall" ];

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

} ''
  ln -s ${podman-unwrapped.man} $man

  mkdir -p $out/bin
  ln -s ${podman-unwrapped}/etc $out/etc
  ln -s ${podman-unwrapped}/lib $out/lib
  ln -s ${podman-unwrapped}/share $out/share
  makeWrapper ${podman-unwrapped}/bin/podman $out/bin/podman \
    --set CONTAINERS_HELPER_BINARY_DIR ${helpersBin}/bin \
    --prefix PATH : ${lib.escapeShellArg binPath}
''

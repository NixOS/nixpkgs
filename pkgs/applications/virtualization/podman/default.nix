{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, installShellFiles
, buildGoModule
, gpgme
, lvm2
, btrfs-progs
, libapparmor
, libseccomp
, libselinux
, systemd
, go-md2man
, nixosTests
, python3
, makeWrapper
, runtimeShell
, symlinkJoin
, extraPackages ? [ ]
, runc
, crun
, conmon
, slirp4netns
, fuse-overlayfs
, util-linux
, iptables
, iproute2
, catatonit
, gvproxy
, aardvark-dns
, netavark
, testers
, podman
}:
let
  # do not add qemu to this wrapper, store paths get written to the podman vm config and break when GCed

  binPath = lib.makeBinPath (lib.optionals stdenv.isLinux [
    runc
    crun
    conmon
    fuse-overlayfs
    util-linux
    iptables
    iproute2
  ] ++ extraPackages);

  helpersBin = symlinkJoin {
    name = "podman-helper-binary-wrapper";

    # this only works for some binaries, others may need to be be added to `binPath` or in the modules
    paths = [
      gvproxy
    ] ++ lib.optionals stdenv.isLinux [
      aardvark-dns
      catatonit # added here for the pause image and also set in `containersConf` for `init_path`
      netavark
      slirp4netns
    ];
  };
in
buildGoModule rec {
  pname = "podman";
  version = "4.7.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "podman";
    rev = "v${version}";
    hash = "sha256-xbU2F/QYtTKeZacTmwKDfIGuUg9VStEO/jkpChK0DyU=";
  };

  patches = [
    # we intentionally don't build and install the helper so we shouldn't display messages to users about it
    ./rm-podman-mac-helper-msg.patch
  ];

  vendorHash = null;

  doCheck = false;

  outputs = [ "out" "man" ];

  nativeBuildInputs = [ pkg-config go-md2man installShellFiles makeWrapper python3 ];

  buildInputs = lib.optionals stdenv.isLinux [
    btrfs-progs
    gpgme
    libapparmor
    libseccomp
    libselinux
    lvm2
    systemd
  ];

  HELPER_BINARIES_DIR = "${PREFIX}/libexec/podman"; # used in buildPhase & installPhase
  PREFIX = "${placeholder "out"}";

  buildPhase = ''
    runHook preBuild
    patchShebangs .
    substituteInPlace Makefile --replace "/bin/bash" "${runtimeShell}"
    ${if stdenv.isDarwin then ''
      make podman-remote # podman-mac-helper uses FHS paths
    '' else ''
      make bin/podman bin/rootlessport bin/quadlet
    ''}
    make docs
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    ${if stdenv.isDarwin then ''
      install bin/darwin/podman -Dt $out/bin
    '' else ''
      make install.bin install.systemd
    ''}
    make install.completions install.man
    mkdir -p ${HELPER_BINARIES_DIR}
    ln -s ${helpersBin}/bin/* ${HELPER_BINARIES_DIR}
    wrapProgram $out/bin/podman \
      --prefix PATH : ${lib.escapeShellArg binPath}
    runHook postInstall
  '';

  postFixup = lib.optionalString stdenv.isLinux ''
    RPATH=$(patchelf --print-rpath $out/bin/.podman-wrapped)
    patchelf --set-rpath "${lib.makeLibraryPath [ systemd ]}":$RPATH $out/bin/.podman-wrapped
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = podman;
      command = "HOME=$TMPDIR podman --version";
    };
  } // lib.optionalAttrs stdenv.isLinux {
    inherit (nixosTests) podman;
    # related modules
    inherit (nixosTests)
      podman-tls-ghostunnel
      ;
    oci-containers-podman = nixosTests.oci-containers.podman;
  };

  meta = with lib; {
    homepage = "https://podman.io/";
    description = "A program for managing pods, containers and container images";
    longDescription = ''
      Podman (the POD MANager) is a tool for managing containers and images, volumes mounted into those containers, and pods made from groups of containers. Podman runs containers on Linux, but can also be used on Mac and Windows systems using a Podman-managed virtual machine. Podman is based on libpod, a library for container lifecycle management that is also contained in this repository. The libpod library provides APIs for managing containers, pods, container images, and volumes.

      To install on NixOS, please use the option `virtualisation.podman.enable = true`.
    '';
    changelog = "https://github.com/containers/podman/blob/v${version}/RELEASE_NOTES.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ marsam ] ++ teams.podman.members;
  };
}

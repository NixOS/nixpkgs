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
}:

buildGoModule rec {
  pname = "podman";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "podman";
    rev = "v${version}";
    sha256 = "sha256-crlOF8FoLlDulJJ8t8M1kk6JhSZdJU1VtR+G0O6VngM=";
  };

  vendorSha256 = null;

  doCheck = false;

  outputs = [ "out" "man" ] ++ lib.optionals stdenv.isLinux [ "rootlessport" ];

  nativeBuildInputs = [ pkg-config go-md2man installShellFiles ];

  buildInputs = lib.optionals stdenv.isLinux [
    btrfs-progs
    gpgme
    libapparmor
    libseccomp
    libselinux
    lvm2
    systemd
  ];

  buildPhase = ''
    runHook preBuild
    patchShebangs .
    ${if stdenv.isDarwin then ''
      make podman-remote # podman-mac-helper uses FHS paths
    '' else ''
      make bin/podman bin/rootlessport
    ''}
    make docs
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p {$out/{bin,etc,lib,share},$man} # ensure paths exist for the wrapper
    ${if stdenv.isDarwin then ''
      mv bin/{darwin/podman,podman}
    '' else ''
      install -Dm644 cni/87-podman-bridge.conflist -t $out/etc/cni/net.d
      install -Dm644 contrib/tmpfile/podman.conf -t $out/lib/tmpfiles.d
      for s in contrib/systemd/**/*.in; do
        substituteInPlace "$s" --replace "@@PODMAN@@" "podman" # don't use unwrapped binary
      done
      PREFIX=$out make install.systemd
      install -Dm555 bin/rootlessport -t $rootlessport/bin
    ''}
    install -Dm555 bin/podman -t $out/bin
    PREFIX=$out make install.completions
    MANDIR=$man/share/man make install.man
    runHook postInstall
  '';

  postFixup = lib.optionalString stdenv.isLinux ''
    RPATH=$(patchelf --print-rpath $out/bin/podman)
    patchelf --set-rpath "${lib.makeLibraryPath [ systemd ]}":$RPATH $out/bin/podman
  '';

  passthru.tests = {
    inherit (nixosTests) podman;
    # related modules
    inherit (nixosTests)
      podman-tls-ghostunnel
      podman-dnsname
      ;
    oci-containers-podman = nixosTests.oci-containers.podman;
  };

  meta = with lib; {
    homepage = "https://podman.io/";
    description = "A program for managing pods, containers and container images";
    changelog = "https://github.com/containers/podman/blob/v${version}/RELEASE_NOTES.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ marsam ] ++ teams.podman.members;
    # requires >= 10.13 SDK https://github.com/NixOS/nixpkgs/issues/101229
    # Undefined symbols for architecture x86_64: "_utimensat"
    broken = stdenv.isDarwin && stdenv.isx86_64;
  };
}

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
  version = "3.4.1";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "podman";
    rev = "v${version}";
    sha256 = "sha256-+6ALwm1Hc76rYwlQN0r8zX2n+nxBk5iW4AHWBlzAIOc=";
  };

  vendorSha256 = null;

  doCheck = false;

  outputs = [ "out" "man" ];

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
    ${if stdenv.isDarwin
      then "make podman-remote"
      else "make podman"}
    make docs
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
  '' + lib.optionalString stdenv.isDarwin ''
    mv bin/{darwin/podman,podman}
  '' + ''
    install -Dm555 bin/podman $out/bin/podman
    installShellCompletion --bash completions/bash/*
    installShellCompletion --fish completions/fish/*
    installShellCompletion --zsh completions/zsh/*
    MANDIR=$man/share/man make install.man-nobuild
    install -Dm644 cni/87-podman-bridge.conflist -t $out/etc/cni/net.d
    install -Dm644 contrib/tmpfile/podman.conf -t $out/lib/tmpfiles.d
    install -Dm644 contrib/systemd/system/podman.{socket,service} -t $out/lib/systemd/system
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
  };

  meta = with lib; {
    homepage = "https://podman.io/";
    description = "A program for managing pods, containers and container images";
    changelog = "https://github.com/containers/podman/blob/v${version}/changelog.txt";
    license = licenses.asl20;
    maintainers = with maintainers; [ marsam ] ++ teams.podman.members;
    platforms = platforms.unix;
  };
}

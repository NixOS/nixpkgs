{ stdenv
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
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "podman";
    rev = "v${version}";
    sha256 = "sha256-+z28Z0KvaJa32+eTGFsNX8g/WVd3BohKoBnNPU/kpWM=";
  };

  vendorSha256 = null;

  doCheck = false;

  outputs = [ "out" "man" ];

  nativeBuildInputs = [ pkg-config go-md2man installShellFiles ];

  buildInputs = stdenv.lib.optionals stdenv.isLinux [
    btrfs-progs
    gpgme
    libapparmor
    libseccomp
    libselinux
    lvm2
    systemd
  ];

  buildPhase = ''
    patchShebangs .
    ${if stdenv.isDarwin
      then "make podman-remote"
      else "make podman"}
    make docs
  '';

  installPhase = stdenv.lib.optionalString stdenv.isDarwin ''
    mv bin/{podman-remote,podman}
  '' + ''
    install -Dm555 bin/podman $out/bin/podman
    installShellCompletion --bash completions/bash/*
    installShellCompletion --fish completions/fish/*
    installShellCompletion --zsh completions/zsh/*
    MANDIR=$man/share/man make install.man-nobuild
  '';

  passthru.tests = { inherit (nixosTests) podman; };

  meta = with stdenv.lib; {
    homepage = "https://podman.io/";
    description = "A program for managing pods, containers and container images";
    changelog = "https://github.com/containers/podman/blob/v${version}/changelog.txt";
    license = licenses.asl20;
    maintainers = with maintainers; [ marsam ] ++ teams.podman.members;
    platforms = platforms.unix;
  };
}

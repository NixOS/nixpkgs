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
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "libpod";
    rev = "v${version}";
    sha256 = "0jvqzn1q52z6aka98d2i3dyn2i8xld7xvmi2zfxgm9g53wdgi2g2";
  };

  vendorSha256 = null;

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
      then "make CGO_ENABLED=0 BUILDTAGS='remoteclient containers_image_openpgp exclude_graphdriver_devicemapper' varlink_generate all"
      else "make podman docs"}
  '';

  installPhase = ''
    install -Dm555 bin/podman $out/bin/podman
    installShellCompletion --bash completions/bash/podman
    installShellCompletion --zsh completions/zsh/_podman
    MANDIR=$man/share/man make install.man
  '';

  passthru.tests.podman = nixosTests.podman;

  meta = with stdenv.lib; {
    homepage = "https://podman.io/";
    description = "A program for managing pods, containers and container images";
    license = licenses.asl20;
    maintainers = with maintainers; [ marsam ] ++ teams.podman.members;
    platforms = platforms.unix;
    broken = stdenv.isDarwin;
  };
}

{
  lib,
  btrfs-progs,
  buildGoModule,
  fetchFromGitHub,
  glibc,
  gpgme,
  installShellFiles,
  libapparmor,
  libseccomp,
  libselinux,
  lvm2,
  pkg-config,
  nixosTests,
  go-md2man,
}:

buildGoModule rec {
  pname = "cri-o";
  version = "1.34.3";

  src = fetchFromGitHub {
    owner = "cri-o";
    repo = "cri-o";
    rev = "v${version}";
    hash = "sha256-2Avq1EzK+i+16yoPM7j6IlavDi2oUS5A1hOIdzVThEQ=";
  };
  vendorHash = null;

  doCheck = false;

  outputs = [
    "out"
    "man"
  ];
  nativeBuildInputs = [
    installShellFiles
    go-md2man
    pkg-config
  ];

  buildInputs = [
    btrfs-progs
    gpgme
    libapparmor
    libseccomp
    libselinux
    lvm2
  ]
  ++ lib.optionals (glibc != null) [
    glibc
    glibc.static
  ];

  BUILDTAGS = "apparmor seccomp selinux containers_image_openpgp containers_image_ostree_stub";
  buildPhase = ''
    runHook preBuild
    sed -i 's;\thack/;\tbash ./hack/;g' Makefile
    make binaries docs BUILDTAGS="$BUILDTAGS"
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/* -t $out/bin

    for shell in bash fish zsh; do
      installShellCompletion --$shell completions/$shell/*
    done

    install contrib/cni/*.conflist -Dt $out/etc/cni/net.d
    install crictl.yaml -Dt $out/etc

    installManPage docs/*.[1-9]
    runHook postInstall
  '';

  passthru.tests = { inherit (nixosTests) cri-o; };

  meta = with lib; {
    homepage = "https://cri-o.io";
    description = ''
      Open Container Initiative-based implementation of the
      Kubernetes Container Runtime Interface
    '';
    license = licenses.asl20;
    teams = [ teams.podman ];
    platforms = platforms.linux;
  };
}
